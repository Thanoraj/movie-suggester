package controllers

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/Thanoraj/movie-suggester/backend/data"
	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/models"
	"github.com/Thanoraj/movie-suggester/backend/services"
	"github.com/gofiber/fiber/v2"
)

const userToken string = "USER_TOKEN"

func Home(c *fiber.Ctx) error {
	return c.SendString("Hello world! 👋")
}

func RegisterUser(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
		})
	}

	password, _ := services.HashPassword(body["password"])

	var user models.User

	database.GetUserWithEmail(body["email"], user)

	fmt.Println(user)

	if user.ID != 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"message": "user already exist",
		})
	}

	tempUser := &models.TempUser{
		Name:                  body["name"],
		Email:                 body["email"],
		Password:              password,
		VerificationExpiresAt: time.Now(),
		Verified:              false,
	}

	fmt.Println(tempUser)

	err := database.SaveTableRow(tempUser)

	if err != nil {

		if database.IsDuplicateEmailError(err) {
			return c.Status(fiber.StatusCreated).JSON(fiber.Map{
				"success": true,
				"message": "user created successfully",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}

	fmt.Printf("User registered with %s", tempUser.Email)

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "user created successfully",
		"success": true,
	})

}
func SendVerificationEmail(c *fiber.Ctx) error {
	fmt.Println("Send verification")
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
		})
	}

	fmt.Println(body)

	var tempUser models.TempUser

	database.GetUserWithEmail(body["email"], &tempUser)

	fmt.Println(tempUser.ID)

	if tempUser.ID == 0 {

		removeCookie(c)

		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": data.UserNotFound,
			"success": false,
		})
	}

	expirationTime := time.Now().Add(5 * time.Minute)

	emailToken, err := services.GetEmailToken(tempUser.Email, expirationTime)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "failed to generate authentication token",
			"success": false,
		})
	}

	fmt.Println(emailToken)
	err = services.SendVerificationEmail(tempUser.Email, emailToken)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}

	tempUser.Verified = false

	tempUser.VerificationExpiresAt = expirationTime

	database.UpdateUserData(&tempUser)

	fmt.Println("Sent verification")

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "verification email sent successfully",
	})

}

func VerifyEmail(c *fiber.Ctx) error {

	token := c.Query("token")

	email, err := services.GetEmailFromToken(token)

	if err != nil {
		if strings.Contains(err.Error(), "token is expired") {
			return c.Status(fiber.StatusGone).SendString("The link is expired use app to re-generate the verification link.")
		}
		return c.Status(fiber.StatusBadRequest).SendString("Invalid url. Please check the url or re-generate it")
	}

	var tempUser models.TempUser

	database.GetUserWithEmail(email, &tempUser)

	if tempUser.ID == 0 {
		return c.Status(fiber.StatusBadRequest).SendString("Invalid url. Please check the url or re-generate it")
	}

	user := models.User{
		Email:    tempUser.Email,
		Password: tempUser.Password,
		Name:     tempUser.Name,
	}

	err = database.UpdateUserData(&user)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).SendString("User verification failed")
	}

	tempUser.Verified = true
	err = database.UpdateUserData(&tempUser)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).SendString("User Created successfully. Please restart the app and login with the credentials")
	}

	return c.Status(fiber.StatusOK).SendString("user verified successfully")

}

func GetVerificationStatus(c *fiber.Ctx) error {
	fmt.Println("GetVerificationStatus")

	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
			"result": fiber.Map{
				"verified": false,
				"expired":  false,
			},
		})
	}

	fmt.Println(body)

	var tempUser models.TempUser

	database.GetUserWithEmail(body["email"], &tempUser)

	if tempUser.ID == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": data.UserNotFound,
			"success": false,
			"result": fiber.Map{
				"verified": false,
				"expired":  false,
			},
		})
	}

	if !tempUser.Verified && tempUser.VerificationExpiresAt.Before(time.Now()) {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"message": "verification url expired. Please click resend button and verify the email.",
			"success": true,
			"result": fiber.Map{
				"verified": false,
				"expired":  true,
			},
		})
	} else if !tempUser.Verified {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"message": "user not verified yet",
			"success": true,
			"result": fiber.Map{
				"verified": false,
				"expired":  false,
			},
		})
	}

	var user models.User

	err := database.GetUserWithEmail(tempUser.Email, &user)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": data.LoginAgainMsg,
			"success": false,
			"result": fiber.Map{
				"verified": true,
				"expired":  false,
			},
		})
	}

	expirationTime := time.Now().Add(365 * 24 * time.Hour)
	fmt.Println(user)
	token, err := services.GetUserToken(user.ID, expirationTime)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": data.LoginAgainMsg,
			"success": false,
			"result": fiber.Map{
				"verified": true,
				"expired":  false,
				"user":     user,
			},
		})
	}

	clientType := c.Get("X-Client-Type")
	if clientType == "web" {
		cookie := fiber.Cookie{
			Name:     userToken,
			Value:    token,
			Expires:  expirationTime,
			HTTPOnly: true,
		}

		c.Cookie(&cookie)

		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"success": true,
			"message": "email verified successfully",
			"result": fiber.Map{
				"verified": true,
				"expired":  false,
				"user":     user,
			},
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "email verified successfully",
		"result": fiber.Map{
			"verified": true,
			"expired":  false,
			"token":    token,
			"user":     user,
		},
	})

}

func GetUser(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	var user models.User

	database.GetUserWithID(userID, &user)

	if user.ID == 0 {

		removeCookie(c)

		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": data.UserNotFound,
			"success": false,
		})
	}

	return c.JSON(fiber.Map{
		"message": "fetched user successfully",
		"success": true,
		"result":  user,
	})

}

func LoginUser(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
		})
	}

	var user models.User

	database.GetUserWithEmail(body["email"], &user)

	if user.ID == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": data.UserNotFound,
			"success": false,
		})
	}

	if err := services.ComparePasswords(user.Password, body["password"]); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "in correct password",
			"success": false,
		})
	}

	fmt.Println(strconv.Itoa(int(user.ID)))

	expirationTime := time.Now().Add(24 * time.Hour)

	token, err := services.GetUserToken(user.ID, expirationTime)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "could not login the user",
			"success": false,
		})
	}

	clientType := c.Get("X-Client-Type")
	if clientType == "web" {
		cookie := fiber.Cookie{
			Name:     userToken,
			Value:    token,
			Expires:  expirationTime,
			HTTPOnly: true,
		}

		c.Cookie(&cookie)

		return c.JSON(fiber.Map{
			"message": "user logged in successfully",
			"success": true,
			"user":    user,
		})
	}

	return c.JSON(fiber.Map{
		"message": "user logged in successfully",
		"success": true,
		"result":  user,
		"token":   token,
	})

}

func LogoutUser(c *fiber.Ctx) error {

	removeCookie(c)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "user logged out successfully",
		"success": true,
	})

}

func removeCookie(c *fiber.Ctx) {
	cookie := fiber.Cookie{
		Name:     userToken,
		Value:    "",
		Expires:  time.Now().Add(-1 * time.Hour),
		HTTPOnly: true,
	}

	c.Cookie(&cookie)
}

func DeleteUser(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	database.DeleteUserWithID(userID, data.UserTableName)

	removeCookie(c)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
	})

}

func DeleteUserWithEmail(c *fiber.Ctx) error {

	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
		})
	}

	var user models.User
	database.GetUserWithEmail(body["email"], &user)

	database.DeleteUserWithID(user.ID, data.UserTableName)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "user deleted successfully",
	})

}
