package database

import "github.com/Thanoraj/movie-suggester/backend/models"

func GetUserWithEmail(email string, user *models.User) error {
	return DB.Where("email = ?", email).First(user).Error
}

func GetUserWithID(userID uint, user *models.User) error {
	return  DB.Where("Id = ?", userID).First(user).Error
	

}
