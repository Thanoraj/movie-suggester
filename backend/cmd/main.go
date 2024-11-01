package main

import (
	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/router"
	"github.com/Thanoraj/movie-suggester/backend/services"
)

func main() {
	services.InitEnvVariables()
	database.InitDB()
	router.InitApp()
}
