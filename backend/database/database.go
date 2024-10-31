package database

import (
	"fmt"
	"log"

	"github.com/Thanoraj/movie-suggester/backend/models"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	// Define the database connection string
	dsn := "root:pass@1108@/movie_suggester_db"

	// Open a database connection
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Error opening database: %v\n", err)
	}

	DB = db

	DB.AutoMigrate(&models.User{})

	fmt.Println("Connected to the database successfully!")
}
