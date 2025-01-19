package database

import (
	"fmt"

	"github.com/Thanoraj/movie-suggester/backend/models"
)

func GetUserWithEmail(email string, tableModel models.TableModel) error {
	return DB.Table(tableModel.TableName()).Where("email = ?", email).First(tableModel).Error
}

func GetUserWithID(userID uint, tableModel models.TableModel) error {
	return DB.Table(tableModel.TableName()).Where("Id = ?", userID).First(tableModel).Error
}

func GetSearchCache(query string, tableModel models.TableModel) error {
	fmt.Println("Here in db")
	return DB.Table(tableModel.TableName()).Where("query = ?", query).First(tableModel).Error
}
