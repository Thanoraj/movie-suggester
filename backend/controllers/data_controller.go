package controllers

import (
	"github.com/Thanoraj/movie-suggester/backend/data"
	"github.com/gofiber/fiber/v2"
)

func GetGenreData(c *fiber.Ctx) error {

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "fetched user successfully",
		"success": true,
		"result": fiber.Map{
			"genres": data.Genres,
		},
	})
}

func GetLanguageData(c *fiber.Ctx) error {

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "fetched user successfully",
		"success": true,
		"result": fiber.Map{
			"languages": data.Languages,
		},
	})
}

func GetGenreLanguageData(c *fiber.Ctx) error {

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "fetched user successfully",
		"success": true,
		"result": fiber.Map{
			"genres":    data.Genres,
			"languages": data.Languages,
		},
	})
}
