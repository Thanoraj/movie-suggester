package services

import (
	"fmt"

	"github.com/Thanoraj/movie-suggester/backend/config"
	"gopkg.in/gomail.v2"
)

func SendVerificationEmail(email, token string) error {
	verificationLink := fmt.Sprintf("http://127.0.0.1:8000/api/v1/verify-email?token=%s", token)

	message := gomail.NewMessage()
	message.SetHeader("From", config.SMTP_USERNAME)
	message.SetHeader("To", email)
	message.SetHeader("Subject", "Verify Your Email")
	message.SetBody("text/plain", fmt.Sprintf("Click the link to verify your email: %s", verificationLink))

	dialer := gomail.NewDialer(config.SMTP_HOST, config.SMTP_PORT, config.SMTP_USERNAME, config.SMTP_PASSWORD)
	return dialer.DialAndSend(message)
}

func DeleteUser(userID uint) {

}
