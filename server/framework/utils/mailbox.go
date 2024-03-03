package Utils

import "gopkg.in/gomail.v2"

func SendMail(to string, subject string, content string) bool {
	status := true
	mail := gomail.NewMessage()
	mail.SetHeader("From", mail.FormatAddress("open@wileho.com", "GEEKROS"))
	mail.SetHeader("To", to)
	mail.SetHeader("Subject", subject)
	mail.SetBody("text/html", content)
	send := gomail.NewDialer("smtp.qq.com", 587, "open@wileho.com", "")
	if err := send.DialAndSend(mail); err != nil {
		status = false
	}
	return status
}
