/**
#*****************************************************************************
# @file    mail.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Utils

import "gopkg.in/gomail.v2"

func SendMail(to string, subject string, content string) bool {
	status := true
	mail := gomail.NewMessage()
	mail.SetHeader("From", mail.FormatAddress("", ""))
	mail.SetHeader("To", to)
	mail.SetHeader("Subject", subject)
	mail.SetBody("text/html", content)
	send := gomail.NewDialer("smtp.qq.com", 587, "", "")
	if err := send.DialAndSend(mail); err != nil {
		status = false
	}
	return status
}
