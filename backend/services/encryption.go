package services

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GetUserToken(userID string, expirationTime time.Time) (string, error) {

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(expirationTime),
		Issuer:    userID,
	})

	return token.SignedString(JwtKey)

}
