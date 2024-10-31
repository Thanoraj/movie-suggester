package database

import "github.com/Thanoraj/movie-suggester/backend/models"

func GetUserWithEmail(email string, user *models.User) {
	DB.Where("email = ?", email).First(user)
}
