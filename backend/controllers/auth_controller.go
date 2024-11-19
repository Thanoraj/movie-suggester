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
	user := models.User{
		Name:     body["name"],
		Email:    body["email"],
		Password: password,
	}

	err := database.WriteUserData(&user)

	if err != nil {
		switch err.Error() {
		case "email already exist":
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"success": false,
				"message": err.Error(),
			})
		default:
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"success": false,
				"message": err.Error(),
			})
		}

	}

	fmt.Printf("User registered with %s", user.Email)

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "user created successfully",
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

	if user.Id == 0 {
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

	fmt.Println(strconv.Itoa(int(user.Id)))

	expirationTime := time.Now().Add(24 * time.Hour)

	token, err := services.GetUserToken(user.Id, expirationTime)
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

func GetUser(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	var user models.User

	database.GetUserWithID(userID, &user)

	if user.Id == 0 {

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

func SendVerificationEmail(c *fiber.Ctx) error {

	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
		})
	}

	fmt.Println(body)

	var user models.User

	database.GetUserWithEmail(body["email"], &user)

	if user.Id == 0 {

		removeCookie(c)

		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": data.UserNotFound,
			"success": false,
		})
	}

	expirationTime := time.Now().Add(5 * time.Minute)

	emailToken, err := services.GetEmailToken(user.Email, expirationTime)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "failed to generate authentication token",
			"success": false,
		})
	}
	err = services.SendVerificationEmail(user.Email, emailToken)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}

	user.Verified = false

	database.UpdateUserData(&user)

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

	var user models.User

	database.GetUserWithEmail(email, &user)

	if user.Id == 0 {
		return c.Status(fiber.StatusBadRequest).SendString("Invalid url. Please check the url or re-generate it")
	}

	user.Verified = true

	err = database.UpdateUserData(&user)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).SendString("User verification failed")
	}

	return c.Status(fiber.StatusOK).SendString("user verified successfully")

}

func GetVerificationStatus(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": data.InvalidRequestFormat,
			"success": false,
		})
	}

	fmt.Println(body)

	var user models.User

	database.GetUserWithEmail(body["email"], &user)

	if user.Id == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": data.UserNotFound,
			"success": false,
		})
	}

	if !user.Verified {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"message": "user not verified yet",
			"success": false,
		})
	}

	expirationTime := time.Now().Add(24 * time.Hour)

	token, err := services.GetUserToken(user.Id, expirationTime)
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

		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"success": true,
			"message": "email verified successfully",
			"result":  user,
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "email verified successfully",
		"result":  user,
		"token":   token,
	})

}

func DeleteUser(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	database.DeleteUserWithID(userID)

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

	database.DeleteUserWithID(user.Id)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "user deleted successfully",
	})

}
