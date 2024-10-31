package database

import (
	"errors"
	"fmt"

	"github.com/Thanoraj/movie-suggester/backend/models"
)

func WriteUserData(user *models.User) error {
	result := DB.Create(&user)
	if result.Error != nil {
		if isDuplicateEmailError(result.Error) {
			return errors.New("email already exist")
		}
		fmt.Println(result.Error)
		return errors.New("error creating user in the database")
	}

	return nil

}
