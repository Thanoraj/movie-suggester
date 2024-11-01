package database

import "github.com/Thanoraj/movie-suggester/backend/models"

func GetUserWithEmail(email string, user *models.User) {
	DB.Where("email = ?", email).First(user)
}

func GetUserWithID(userID uint, user *models.User) {
	DB.Where("Id = ?", userID).First(user)

}
