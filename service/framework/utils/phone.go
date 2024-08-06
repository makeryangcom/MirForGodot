/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"
	"time"
)

func MobileFormat(str string) string {
	re, _ := regexp.Compile("(\\d{3})(\\d{6})(\\d{2})")
	return re.ReplaceAllString(str, "$1******$3")
}

type SendSmsRequest struct {
	PhoneNumberSet   []string `json:"PhoneNumberSet,omitempty"`
	SmsSdkAppId      string   `json:"SmsSdkAppId,omitempty"`
	TemplateId       string   `json:"TemplateId,omitempty"`
	SignName         string   `json:"SignName,omitempty"`
	TemplateParamSet []string `json:"TemplateParamSet,omitempty"`
	ExtendCode       string   `json:"ExtendCode,omitempty"`
	SessionContext   string   `json:"SessionContext,omitempty"`
	SenderId         string   `json:"SenderId,omitempty"`
}

func sha256hex(s string) string {
	b := sha256.Sum256([]byte(s))
	return hex.EncodeToString(b[:])
}

func hmacsha256(s, key string) string {
	hashed := hmac.New(sha256.New, []byte(key))
	hashed.Write([]byte(s))
	return string(hashed.Sum(nil))
}

func SendMessage(form string, phone string, info string) bool {

	status := true

	secretId := ""
	secretKey := ""
	host := "sms.tencentcloudapi.com"
	algorithm := "TC3-HMAC-SHA256"
	service := "sms"
	version := "2021-01-11"
	action := "SendSms"
	region := "ap-guangzhou"
	timestamp := time.Now().Unix()

	httpRequestMethod := "POST"
	canonicalURI := "/"
	canonicalQueryString := ""
	canonicalHeaders := "content-type:application/json; charset=utf-8\n" + "host:" + host + "\n"
	signedHeaders := "content-type;host"

	request := SendSmsRequest{
		SmsSdkAppId:      "",
		SignName:         "MakerYang",
		TemplateId:       "665293",
		TemplateParamSet: []string{info, "5"},
		PhoneNumberSet:   []string{"+86" + phone},
		SessionContext:   "{1}为您的验证码，请于{2}分钟内填写。如非本人操作，请忽略本短信。",
	}

	payload, _ := json.Marshal(request)
	hashedRequestPayload := sha256hex(string(payload))
	canonicalRequest := fmt.Sprintf("%s\n%s\n%s\n%s\n%s\n%s", httpRequestMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedRequestPayload)

	date := time.Unix(timestamp, 0).UTC().Format("2006-01-02")
	credentialScope := fmt.Sprintf("%s/%s/tc3_request", date, service)
	hashedCanonicalRequest := sha256hex(canonicalRequest)
	string2sign := fmt.Sprintf("%s\n%d\n%s\n%s", algorithm, timestamp, credentialScope, hashedCanonicalRequest)

	secretDate := hmacsha256(date, "TC3"+secretKey)
	secretService := hmacsha256(service, secretDate)
	secretSigning := hmacsha256("tc3_request", secretService)
	signature := hex.EncodeToString([]byte(hmacsha256(string2sign, secretSigning)))

	authorization := fmt.Sprintf("%s Credential=%s/%s, SignedHeaders=%s, Signature=%s", algorithm, secretId, credentialScope, signedHeaders, signature)

	url := fmt.Sprintf("https://%s", host)

	req, err := http.NewRequest("POST", url, bytes.NewBufferString(string(payload)))
	if err != nil {
		status = false
		return status
	}

	req.Header.Set("Authorization", authorization)
	req.Header.Set("Content-Type", "application/json; charset=utf-8")
	req.Header.Set("Host", host)
	req.Header.Set("X-TC-Action", action)
	req.Header.Set("X-TC-Timestamp", fmt.Sprintf("%d", timestamp))
	req.Header.Set("X-TC-Version", version)
	req.Header.Set("X-TC-Region", region)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		status = false
		return status
	}
	defer resp.Body.Close()

	return true
}
