package services

import "golang.org/x/crypto/bcrypt"

func HashPassword(password string) ([]byte, error) {
	return bcrypt.GenerateFromPassword([]byte(password), 14)
}

func ComparePasswords(password1 []byte, password2 string) error {
	return bcrypt.CompareHashAndPassword(password1, []byte(password2))
}
