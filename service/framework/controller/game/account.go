/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package GameController

import (
	"Service/framework/database"
	"Service/framework/database/game_account_data"
	"Service/framework/database/game_code_data"
	"Service/framework/utils"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"math/rand"
	"time"
)

func MailCode(c *gin.Context) {

	referer, _ := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	mail := c.DefaultQuery("mail", "")
	if mail == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	randNumber := rand.New(rand.NewSource(time.Now().UnixNano()))
	code := fmt.Sprintf("%06v", randNumber.Int31n(1000000))

	codeDatabase := Database.New(GameCodeData.TableName)
	codeData := &GameCodeData.Data{}
	codeData.CodeMail = mail
	codeData.CodePhone = ""
	codeData.CodeContent = code
	err := codeDatabase.CreateData(codeData)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	send := Utils.SendMail(mail, "注册/登录验证码："+codeData.CodeContent, "你的账号注册/登录验证码为："+codeData.CodeContent)
	if !send {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}

type responseMailLogin struct {
	Account GameAccountData.Return `json:"account"`
	Token   string                 `json:"token"`
}

func MailLogin(c *gin.Context) {

	returnData := responseMailLogin{}

	referer, _ := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	email := c.DefaultQuery("email", "")
	if email == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	password := c.DefaultQuery("password", "")
	if password == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	accountDatabase := Database.New(GameAccountData.TableName)
	accountData := GameAccountData.Data{}
	accountWhere := fmt.Sprintf("account_mail = %q AND account_password = %q", email, Utils.EncryptMD5(password))
	err := accountDatabase.GetData(&accountData, accountWhere, "account_id DESC")
	if err != nil {
		Utils.Warning(c, 10000, "账号密码错误", Utils.EmptyData{})
		return
	}

	returnData.Account = GameAccountData.ReturnData(&accountData)
	returnData.Token = Utils.EncodeId(128, accountData.AccountId)

	Utils.Success(c, returnData)
	return
}

type requestMailRegister struct {
	Mail      string `json:"mail"`
	Code      string `json:"code"`
	Password  string `json:"password"`
	Name      string `json:"name"`
	Number    string `json:"number"`
	QuestionA string `json:"question_a"`
	AnswerA   string `json:"answer_a"`
	QuestionB string `json:"question_b"`
	AnswerB   string `json:"answer_b"`
}

func MailRegister(c *gin.Context) {

	referer, _ := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	jsonData := requestMailRegister{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	codeDatabase := Database.New(GameCodeData.TableName)
	codeData := GameCodeData.Data{}
	codeWhere := fmt.Sprintf("code_mail = %q AND code_content = %q", jsonData.Mail, jsonData.Code)
	err = codeDatabase.GetData(&codeData, codeWhere, "code_id DESC")
	if err != nil {
		Utils.Warning(c, 10000, "验证码错误", Utils.EmptyData{})
		return
	}

	accountDatabase := Database.New(GameAccountData.TableName)
	accountData := GameAccountData.Data{}
	accountWhere := fmt.Sprintf("account_mail = %q", jsonData.Mail)
	err = accountDatabase.GetData(&accountData, accountWhere, "account_id DESC")
	if err == nil {
		Utils.Warning(c, 10000, "邮箱已经被占用，请换一个", Utils.EmptyData{})
		return
	}

	AccountGroup := 1
	countWhere := fmt.Sprintf("account_status > %d", 0)
	count, _ := accountDatabase.CountData(countWhere)
	if count == 0 {
		AccountGroup = 10
	}

	setData := &GameAccountData.Data{}
	setData.AccountMail = jsonData.Mail
	setData.AccountPassword = Utils.EncryptMD5(jsonData.Password)
	setData.AccountName = jsonData.Name
	setData.AccountNumber = jsonData.Number
	setData.AccountQuestionA = jsonData.QuestionA
	setData.AccountAnswerA = jsonData.AnswerA
	setData.AccountQuestionB = jsonData.QuestionB
	setData.AccountAnswerB = jsonData.AnswerB
	setData.AccountGroup = AccountGroup
	setData.AccountStatus = 2
	err = accountDatabase.CreateData(setData)
	if err != nil {
		Utils.Error(c, accountData)
		return
	}
	if setData.AccountId == 0 {
		Utils.Error(c, accountData)
		return
	}

	_ = codeDatabase.DeleteData(&GameCodeData.Data{}, fmt.Sprintf("code_mail = %q", jsonData.Mail))

	Utils.Success(c, Utils.EmptyData{})
	return
}

type requestMailChangePassword struct {
	Mail        string `json:"mail"`
	Password    string `json:"password"`
	NewPassword string `json:"new_password"`
}

func MailChangePassword(c *gin.Context) {

	referer, _ := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	jsonData := requestMailChangePassword{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	accountDatabase := Database.New(GameAccountData.TableName)
	accountData := GameAccountData.Data{}
	accountWhere := fmt.Sprintf("account_mail = %q AND account_password = %q", jsonData.Mail, Utils.EncryptMD5(jsonData.Password))
	err = accountDatabase.GetData(&accountData, accountWhere, "account_id DESC")
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	where := fmt.Sprintf("account_id = %d", accountData.AccountId)
	update := map[string]interface{}{"account_password": Utils.EncryptMD5(jsonData.NewPassword)}
	err = accountDatabase.UpdateData(where, update)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}
