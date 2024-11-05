package controllers

import (
	"strings"

	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/models"
	"github.com/gofiber/fiber/v2"
)

func Preference(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	var user models.User

	err := database.GetUserWithID(userID, &user)

	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}

	preferredGenres := strings.Split(user.PreferredGenres, ", ")
	preferredLanguages := strings.Split(user.PreferredLanguages, ", ")

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "preferences fetched successfully",
		"result": fiber.Map{
			"preferred_genres":    preferredGenres,
			"preferred_languages": preferredLanguages,
		},
	})
}

func UpdatePreferences(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	var userPreferences struct {
		PreferredGenres    []string `json:"preferred_genres"`
		PreferredLanguages []string `json:"preferred_languages"`
	}

	// Parse JSON input
	if err := c.BodyParser(&userPreferences); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"message": "invalid input",
		})
	}

	var user models.User

	err := database.GetUserWithID(userID, &user)

	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}

	preferredGenres := strings.Join(userPreferences.PreferredGenres, ", ")
	preferredLanguages := strings.Join(userPreferences.PreferredLanguages, ", ")

	// Update preferences
	user.PreferredGenres = preferredGenres       //userPreferences.PreferredGenres
	user.PreferredLanguages = preferredLanguages //userPreferences.PreferredLanguages

	err = database.UpdateUserData(&user)

	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "preferences updated successfully",
	})
}
