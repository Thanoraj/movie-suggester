package database

import (
	"github.com/Thanoraj/movie-suggester/backend/models"
)

func GetUserWithEmail(email string, tableModel models.TableModel) error {
	return DB.Table(tableModel.TableName()).Where("email = ?", email).First(tableModel).Error
}

func GetUserWithID(userID uint, tableModel models.TableModel) error {
	return DB.Table(tableModel.TableName()).Where("Id = ?", userID).First(tableModel).Error
}
