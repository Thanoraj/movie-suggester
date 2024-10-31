package main

import (
	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/router"
)

func main() {
	database.InitDB()
	router.InitApp()
}
