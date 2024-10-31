package controllers

import (
	"fmt"
	"strings"

	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/models"
	"github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
	"golang.org/x/crypto/bcrypt"
)

func Home(c *fiber.Ctx) error {
	return c.SendString("Hello world! 👋")
}

func RegisterUser(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return err
	}

	password, _ := bcrypt.GenerateFromPassword([]byte(body["password"]), 14)

	user := models.User{
		Name:     body["name"],
		Email:    body["email"],
		Password: password,
	}

	result := database.DB.Create(&user)
	if result.Error != nil {
		if isDuplicateEmailError(result.Error) {
			return c.Status(fiber.StatusBadRequest).SendString("Email already exist")
		}
		fmt.Println(result.Error)
		return c.Status(500).SendString("Error creating user in the database")
	}

	return c.JSON(user)
}

func LoginUser(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return err
	}

	var user models.User

	database.GetUserWithEmail(body["email"], &user)

	if user.Id == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "User not found",
			"success": false,
		})
	}

	if err := bcrypt.CompareHashAndPassword(user.Password, []byte(body["password"])); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "In correct password",
			"success": false,
		})
	}

	return c.JSON(user)
}

// Helper function to check for duplicate email error\
func isDuplicateEmailError(err error) bool {
	// GORM wraps errors, so we need to unwrap
	if mysqlErr, ok := err.(*mysql.MySQLError); ok {
		switch mysqlErr.Number {
		case 1062: // MySQL code for duplicate entry
			return strings.Contains(err.Error(), "Duplicate entry") && strings.Contains(err.Error(), "email")
		default:
			return false
		}
	}
	return false
}
