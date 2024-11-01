package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

var JWT_KEY []byte
var OPENAI_API_KEY string
var GEMINI_API_KEY string

func InitEnvVariables() {
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found", err.Error())
	}

	key := os.Getenv("JWT_SECRET_KEY")
	if key == "" {
		log.Fatal("JWT_SECRET_KEY environment variable not set")
	}
	JWT_KEY = []byte(key)

	key = os.Getenv("OPENAI_API_KEY")
	if key == "" {
		log.Fatal("OPENAI_API_KEY environment variable not set")
	}
	OPENAI_API_KEY = key

	key = os.Getenv("GEMINI_API_KEY")
	if key == "" {
		log.Fatal("GEMINI_API_KEY environment variable not set")
	}
	GEMINI_API_KEY = key

}
