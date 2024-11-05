package controllers

import (
	"fmt"
	"strconv"
	"time"

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
			"message": "invalid request format",
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

		return c.Status(fiber.StatusCreated).JSON(fiber.Map{
			"success": true,
			"message": "user created successfully",
			"result":  user,
		})
	}

	return c.JSON(fiber.Map{
		"message": "user created successfully",
		"success": true,
		"result":  user,
		"token":   token,
	})

}

func LoginUser(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "invalid request format",
			"success": false,
		})
	}

	var user models.User

	database.GetUserWithEmail(body["email"], &user)

	if user.Id == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "user not found",
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
			"message": "user not found",
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
