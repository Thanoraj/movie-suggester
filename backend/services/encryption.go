package services

import (
	"errors"
	"strconv"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GetUserToken(userID uint, expirationTime time.Time) (string, error) {

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(expirationTime),
		Issuer:    strconv.Itoa(int(userID)),
	})

	return token.SignedString(JWT_KEY)

}

func GetUserIDFromToken(tokenString string) (uint, error) {
	token, err := jwt.ParseWithClaims(tokenString, &jwt.RegisteredClaims{}, func(t *jwt.Token) (interface{}, error) {
		return JWT_KEY, nil
	})

	if err != nil {
		return 0, err
	}

	// Type assertion to access RegisteredClaims fields
	claims, ok := token.Claims.(*jwt.RegisteredClaims)
	if !ok || !token.Valid {
		return 0, errors.New("invalid token")
	}

	val, err := strconv.Atoi(claims.Issuer)
	if err != nil {
		return 0, err
	}

	// Return the Issuer field as the user ID
	return uint(val), nil

}
