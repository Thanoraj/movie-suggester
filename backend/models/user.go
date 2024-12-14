package models

import (
	"time"

	"github.com/Thanoraj/movie-suggester/backend/data"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	ID                 uint           `json:"id" gorm:"primaryKey"`
	Name               string         `json:"name"`
	Email              string         `json:"email" gorm:"unique"`
	Password           []byte         `json:"-"` // Omit password from JSON responses
	PreferredGenres    string         `json:"preferred_genres"`
	PreferredLanguages string         `json:"preferred_languages"`
	DetailsAdded       bool           `json:"detailsAdded" gorm:"default:false"`
	CreatedAt          time.Time      `json:"created_at"` // GORM populates these fields automatically
	UpdatedAt          time.Time      `json:"updated_at"`
	DeletedAt          gorm.DeletedAt `json:"deleted_at" gorm:"index"`
}

func (t User) TableName() string {
	return data.UserTableName
}
