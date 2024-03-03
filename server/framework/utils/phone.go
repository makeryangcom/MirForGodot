package Utils

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"regexp"
)

func MobileFormat(str string) string {
	re, _ := regexp.Compile("(\\d{3})(\\d{6})(\\d{2})")
	return re.ReplaceAllString(str, "$1******$3")
}

func SendMessage(form string, phone string, info string) bool {
	status := true
	if form == "" || phone == "" || info == "" {
		status = false
		return status
	}
	desc := ""
	if form == "express" {
		desc = "【GEEKROS】Hi，" + info + " ，你在GEEKROS的订单已经发货，请留意快递信息，及时查收。"
	}
	if form == "account" {
		desc = "【GEEKROS】你的验证码为：" + info + " ，有效期10分钟，工作人员绝不会索取此验证码，切勿告知他人。"
	}

	apiUrl := "https://smssh1.253.com/msg/v1/send/json"
	params := make(map[string]interface{})
	params["account"] = ""
	params["password"] = ""
	params["phone"] = phone
	params["msg"] = desc
	params["report"] = "false"

	bytesData, err := json.Marshal(params)
	if err != nil {
		status = false
		return status
	}

	reader := bytes.NewReader(bytesData)
	request, err := http.NewRequest("POST", apiUrl, reader)
	if err != nil {
		status = false
		return status
	}

	request.Header.Set("Content-Type", "application/json;charset=UTF-8")
	client := http.Client{}
	resp, err := client.Do(request)
	if err != nil {
		status = false
		return status
	}

	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		status = false
		return status
	}

	log.Println("[PhoneMessage]", string(respBytes))

	return true
}
