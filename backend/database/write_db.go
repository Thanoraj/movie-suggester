package database

import (
	"github.com/Thanoraj/movie-suggester/backend/models"
)

func CreateTableRow(model models.TableModel) error {
	return DB.Table(model.TableName()).Create(model).Error
}

func SaveTableRow(model models.TableModel) error {
	return DB.Table(model.TableName()).Save(model).Error
}

func UpdateUserData(model models.TableModel) error {
	return DB.Table(model.TableName()).Save(model).Error
}
