package models

import (
	"time"

	"github.com/Thanoraj/movie-suggester/backend/data"
	"gorm.io/gorm"
)

type SearchCache struct {
	gorm.Model
	Id        int       `gorm:"primaryKey;autoIncrement" json:"id"`
	Query     string    `gorm:"type:varchar(255);not null" json:"query"`
	Results   string    `gorm:"type:longtext" json:"results"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
}

func (t SearchCache) TableName() string {
	return data.SearchCacheTableName
}
