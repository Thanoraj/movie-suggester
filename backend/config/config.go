package config

import (
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

var JWT_KEY []byte
var OPENAI_API_KEY string
var GEMINI_API_KEY string
var DB_USERNAME string
var DB_PASSWORD string
var DB_NAME string
var OMDB_API_KEY string
var SMTP_HOST string
var SMTP_PORT int
var SMTP_USERNAME string
var SMTP_PASSWORD string

func InitEnvVariables() {
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found", err.Error())
	}

	key := os.Getenv("DB_USERNAME")
	if key == "" {
		log.Fatal("DB_USERNAME environment variable not set")
	}
	DB_USERNAME = key

	key = os.Getenv("DB_PASSWORD")
	if key == "" {
		log.Fatal("DB_PASSWORD environment variable not set")
	}
	DB_PASSWORD = key

	key = os.Getenv("DB_NAME")
	if key == "" {
		log.Fatal("DB_NAME environment variable not set")
	}
	DB_NAME = key

	key = os.Getenv("JWT_SECRET_KEY")
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

	key = os.Getenv("OMDB_API_KEY")
	if key == "" {
		log.Fatal("OMDB_API_KEY environment variable not set")
	}
	OMDB_API_KEY = key

	key = os.Getenv("SMTP_HOST")
	if key == "" {
		log.Fatal("SMTP_HOST environment variable not set")
	}
	SMTP_HOST = key

	key = os.Getenv("SMTP_PORT")
	if key == "" {
		log.Fatal("SMTP_PORT environment variable not set")
	}
	SMTP_PORT, _ = strconv.Atoi(key)

	key = os.Getenv("SMTP_USERNAME")
	if key == "" {
		log.Fatal("SMTP_USERNAME environment variable not set")
	}
	SMTP_USERNAME = key

	key = os.Getenv("SMTP_PASSWORD")
	if key == "" {
		log.Fatal("SMTP_PASSWORD environment variable not set")
	}
	SMTP_PASSWORD = key

}
