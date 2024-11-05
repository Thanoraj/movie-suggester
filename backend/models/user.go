package models

type User struct {
	Id                 uint   `json:"id" gorm:"primaryKey"`
	Name               string `json:"name"`
	Email              string `json:"email" gorm:"unique"`
	Password           []byte `json:"-"` // Omit password from JSON responses
	PreferredGenres    string `json:"preferred_genres"`
	PreferredLanguages string `json:"preferred_languages"`
}
