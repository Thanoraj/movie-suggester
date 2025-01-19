package database

import (
	"fmt"
	"log"

	"github.com/Thanoraj/movie-suggester/backend/config"
	"github.com/Thanoraj/movie-suggester/backend/models"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	// Define the database connection string
	dsn := fmt.Sprintf("%s:%s@/%s?parseTime=True", config.DB_USERNAME, config.DB_PASSWORD, config.DB_NAME)

	// Open a database connection
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Error opening database: %v\n", err)
	}

	DB = db

	DB = DB.Debug()

	DB.AutoMigrate(&models.User{}, &models.TempUser{}, &models.SearchCache{})

	fmt.Println("Connected to the database successfully!")
}
