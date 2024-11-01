package services

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"strings"

	"github.com/Thanoraj/movie-suggester/backend/config"
	"github.com/Thanoraj/movie-suggester/backend/models"
	"github.com/google/generative-ai-go/genai"
	"google.golang.org/api/option"
)

var genAIClient *genai.Client

func InitGeminiClient() {

	ctx := context.Background()
	client, err := genai.NewClient(ctx, option.WithAPIKey(config.GEMINI_API_KEY))
	if err != nil {
		log.Fatal(err)
	}

	genAIClient = client

	fmt.Println("Gemini client initialized")

}

func getGeminiAISuggestion(movies []string) ([]models.GeminiAIMovie, error) {
	ctx := context.Background()
	model := genAIClient.GenerativeModel("gemini-1.5-flash")
	model.ResponseMIMEType = "application/json"

	prompt := `This is my watch list` + strings.Join(movies, ", ") + `generate 5 movie suggestion, using this JSON schema:
                   Movie = {'title': string, 'year':string, 'genre': array<string>}
	           Return: Array<Movie>`

	resp, err := model.GenerateContent(ctx, genai.Text(prompt))
	if err != nil {
		log.Fatal(err)
	}

	return readResponse(resp)

}

func readResponse(resp *genai.GenerateContentResponse) (movies []models.GeminiAIMovie, err error) {

	for _, part := range resp.Candidates[0].Content.Parts {
		if txt, ok := part.(genai.Text); ok {
			if err := json.Unmarshal([]byte(txt), &movies); err != nil {
				return movies, err
			}
			fmt.Println(movies)
		}
	}
	fmt.Println("---")

	return movies, nil
}
