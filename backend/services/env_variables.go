package services

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

var JwtKey []byte

func init() {
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found")
	}

	key := os.Getenv("JWT_SECRET_KEY")
	if key == "" {
		log.Fatal("JWT_SECRET_KEY environment variable not set")
	}
	JwtKey = []byte(key)
}
