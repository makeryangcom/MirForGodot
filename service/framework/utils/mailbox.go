/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"gopkg.in/gomail.v2"
	"strings"
)

func MailFormat(email string) string {
	atIndex := strings.Index(email, "@")
	if atIndex == -1 {
		return email
	}

	prefixLength := 2
	if atIndex < prefixLength {
		prefixLength = atIndex
	}
	prefix := email[:prefixLength]
	starsCount := atIndex - prefixLength
	if starsCount < 0 {
		starsCount = 0
	}
	hiddenPart := strings.Repeat("*", starsCount)
	domain := email[atIndex:]
	return prefix + hiddenPart + domain
}

func SendMail(to string, subject string, content string) bool {

	status := true

	mail := gomail.NewMessage()
	mail.SetHeader("From", mail.FormatAddress("123456789@foxmail.com", "MakerYang"))
	mail.SetHeader("To", to)
	mail.SetHeader("Subject", subject)
	mail.SetBody("text/html", content)

	send := gomail.NewDialer("smtp.qq.com", 587, "123456789@foxmail.com", "123456789")
	if err := send.DialAndSend(mail); err != nil {
		status = false
	}

	return status
}
