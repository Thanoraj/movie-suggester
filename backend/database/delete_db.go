package database

import "github.com/Thanoraj/movie-suggester/backend/models"

func DeleteUserWithID(userID uint) {
	DB.Delete(&models.User{}, userID)

}
