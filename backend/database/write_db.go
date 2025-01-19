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

func SaveCacheResult(model models.SearchCache) error {
	// Attempt to update the row with the matching query
	result := DB.Table(model.TableName()).Where("query = ?", model.Query).Updates(model)
	if result.RowsAffected == 0 {
		// If no rows were updated, create a new record
		return DB.Create(&model).Error
	}
	return result.Error
}
