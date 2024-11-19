package database

import "github.com/Thanoraj/movie-suggester/backend/models"

func DeleteUserWithID(userID uint) error {
	return DB.Delete(&models.User{}, userID).Error

}
