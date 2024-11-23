package database

import "github.com/Thanoraj/movie-suggester/backend/models"

func DeleteUserWithID(userID uint, tableName string) error {
	return DB.Table(tableName).Delete(&models.User{}, userID).Error

}
