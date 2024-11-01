package controllers

import "github.com/gofiber/fiber/v2"

func GetSuggestion(c *fiber.Ctx) error {
	return c.SendString("This is movie suggestion")
}
