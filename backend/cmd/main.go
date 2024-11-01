package main

import (
	"github.com/Thanoraj/movie-suggester/backend/config"
	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/router"
	"github.com/Thanoraj/movie-suggester/backend/services"
)

func main() {
	config.InitEnvVariables()
	database.InitDB()
	services.InitGeminiClient()
	router.InitApp()
}
