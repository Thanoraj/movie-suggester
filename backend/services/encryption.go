package services

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GetUserToken(userID string) (string, error) {
	expirationTime := time.Now().Add(24 * time.Hour)

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(expirationTime),
		Issuer:    userID,
	})

	return token.SignedString(JwtKey)

}
