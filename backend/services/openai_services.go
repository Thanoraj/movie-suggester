package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/Thanoraj/movie-suggester/backend/config"
	"github.com/Thanoraj/movie-suggester/backend/models"
)

func GetOpenaiSuggestion() {

	client := &http.Client{}
	url := "https://api.openai.com/v1/chat/completions"

	// Prepare the request body
	reqBody := models.OpenAIRequest{
		Model: "gpt-3.5-turbo",
		Messages: []models.Message{
			{Role: "user", Content: "What is the capital of France?"},
		},
		MaxTokens:   50,
		Temperature: 0.7,
	}

	reqBodyJSON, err := json.Marshal(reqBody)
	if err != nil {
		log.Fatalf("Error encoding request body: %v", err)
	}

	// Create HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(reqBodyJSON))
	if err != nil {
		log.Fatalf("Error creating request: %v", err)
	}

	// Set headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", config.OPENAI_API_KEY))

	// Execute the request
	resp, err := client.Do(req)
	if err != nil {
		log.Fatalf("Error making request: %v", err)
	}
	defer resp.Body.Close()
	fmt.Println(resp.Body)

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Error reading response: %v", err)
	}

	fmt.Println(respBody)
	var openAIResp models.OpenAIResponse
	if err := json.Unmarshal(respBody, &openAIResp); err != nil {
		log.Fatalf("Error decoding response: %v", err)
	}

	fmt.Println(openAIResp)
	// Print the response content
	if len(openAIResp.Choices) > 0 {
		fmt.Println("OpenAI Response:", openAIResp, openAIResp.Choices[0].Message.Content)
	} else {
		fmt.Println("No response from OpenAI.")
	}

}
