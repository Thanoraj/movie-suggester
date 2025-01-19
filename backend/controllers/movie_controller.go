package controllers

import (
	"fmt"
	"time"

	"github.com/Thanoraj/movie-suggester/backend/models"
	"github.com/Thanoraj/movie-suggester/backend/services"
	"github.com/gofiber/fiber/v2"
)

func GetSuggestion(c *fiber.Ctx) error {

	var body models.GetSuggestionBody

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "invalid request format",
			"success": false,
		})
	}

	response, err := services.GetSuggestion(body.Movies)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"message": "failed to get the suggestion",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "suggestion generated successfully",
		"result":  response,
	})
}

func GetMovie(c *fiber.Ctx) error {
	var body map[string]string

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "invalid request format",
			"success": false,
		})
	}

	movie, err := services.GetMovieData(body["title"], body["year"])

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"message": "failed to get the movie data",
		})
	}

	return c.Status(fiber.StatusOK).JSON(movie)
}

func SearchMovie(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)

	fmt.Println(userID)

	query := c.Query("query")

	// movies, err := services.SearchMovie(query)
	// if err != nil {
	// 	return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
	// 		"message": "Failed to find movie with the query",
	// 		"success": false,
	// 	})
	// }

	fmt.Println(query)
	result, _ := services.GetCachedResults(query)
	fmt.Println(result)
	if result.Results == nil {
		movies, err := services.SearchMovie(query)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Failed to find movie with the query",
				"success": false,
			})
		}

		result.CreatedAt = time.Now()
		result.Results = *movies
		result.Query = query

		_ = services.SaveResultsToCache(query, *movies)

	} else {
		fmt.Println("Cached result")
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"results": result,
	})
}
