package models

import (
	"time"

	"github.com/Thanoraj/movie-suggester/backend/data"
	"gorm.io/gorm"
)

type TempUser struct {
	gorm.Model
	Name                  string    `json:"name"`
	Email                 string    `json:"email" gorm:"unique"`
	Verified              bool      `json:"verified"`
	VerificationExpiresAt time.Time `json:"verificationExpiresAt"`
	Password              []byte    `json:"-" gorm:"type:varbinary(255)"` // Omit password from JSON responses
}

func (t TempUser) TableName() string {
	return data.TempUserTableName
}
