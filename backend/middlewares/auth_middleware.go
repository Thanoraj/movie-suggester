package middlewares

import (
	"strings"

	"github.com/Thanoraj/movie-suggester/backend/services"
	"github.com/gofiber/fiber/v2"
)

// JWTMiddleware validates JWT tokens and extracts the user ID
func AuthMiddleware(c *fiber.Ctx) error {
	// Get token from Authorization header
	tokenString := c.Get("Authorization")
	if tokenString == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Missing authorization header"})
	}


	words := strings.Fields(tokenString) // Splits by any whitespace

	if len(words) != 2 {
		c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"success": false,
			"message": "Insert the token in 'Bearer <user_token>' format",
		})
	}

	token := words[1]

	
	// Parse and validate the token
	services.GetUserIDFromToken(token)

	userID, err := services.GetUserIDFromToken(token)

	if err != nil {
		c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"success": false,
			"message": err.Error(),
		})
	}
	
	// Store user ID in context for use in controllers
	c.Locals("userID", uint(userID))
	return c.Next()
}