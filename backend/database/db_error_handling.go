package database

import (
	"strings"

	"github.com/go-sql-driver/mysql"
)

func IsDuplicateEmailError(err error) bool {
	// GORM wraps errors, so we need to unwrap
	if mysqlErr, ok := err.(*mysql.MySQLError); ok {
		switch mysqlErr.Number {
		case 1062: // MySQL code for duplicate entry
			return strings.Contains(err.Error(), "Duplicate entry") && strings.Contains(err.Error(), "email")
		default:
			return false
		}
	}
	return false
}
