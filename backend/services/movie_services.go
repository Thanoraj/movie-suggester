package services

import "github.com/Thanoraj/movie-suggester/backend/models"

func GetSuggestion(movies []string) ([]models.GeminiAIMovie, error) {
	return getGeminiAISuggestion(movies)
}
