/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package DisktopController

import (
	"Service/framework/database"
	"Service/framework/database/game_account_data"
	"Service/framework/database/game_code_data"
	"Service/framework/utils"
	"fmt"
	"github.com/gin-gonic/gin"
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
	Account    GameAccountData.Return `json:"account"`
	LoginToken string                 `json:"token"`
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
	accountWhere := fmt.Sprintf("account_mail = %q AND account_password = %q AND account_group = %d", email, Utils.EncryptMD5(password), 10)
	err := accountDatabase.GetData(&accountData, accountWhere, "account_id DESC")
	if err != nil {
		Utils.Warning(c, 10000, "20006", Utils.EmptyData{})
		return
	}

	returnData.Account = GameAccountData.ReturnData(&accountData)
	returnData.LoginToken = Utils.EncodeId(128, accountData.AccountId)

	Utils.Success(c, returnData)
	return
}

type responseMailRegister struct {
	Account    GameAccountData.Return `json:"account"`
	LoginToken string                 `json:"token"`
}

func MailRegister(c *gin.Context) {

	returnData := responseMailRegister{}

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

	code := c.DefaultQuery("code", "")
	if code == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	password := c.DefaultQuery("password", "")
	if password == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	codeDatabase := Database.New(GameCodeData.TableName)
	codeData := GameCodeData.Data{}
	codeWhere := fmt.Sprintf("code_mail = %q AND code_content = %q", email, code)
	err := codeDatabase.GetData(&codeData, codeWhere, "code_id DESC")
	if err != nil {
		Utils.Warning(c, 10000, "20007", Utils.EmptyData{})
		return
	}

	accountDatabase := Database.New(GameAccountData.TableName)
	accountData := GameAccountData.Data{}
	accountWhere := fmt.Sprintf("account_mail = %q", email)
	err = accountDatabase.GetData(&accountData, accountWhere, "account_id DESC")
	if err == nil {
		Utils.Warning(c, 10000, "20008", Utils.EmptyData{})
		return
	}

	AccountGroup := 1
	countWhere := fmt.Sprintf("account_status > %d", 0)
	count, _ := accountDatabase.CountData(countWhere)
	if count == 0 {
		AccountGroup = 10
	}

	setData := &GameAccountData.Data{}
	setData.AccountMail = email
	setData.AccountPassword = Utils.EncryptMD5(password)
	setData.AccountName = ""
	setData.AccountNumber = ""
	setData.AccountQuestionA = ""
	setData.AccountAnswerA = ""
	setData.AccountQuestionB = ""
	setData.AccountAnswerB = ""
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

	returnData.LoginToken = Utils.EncodeId(128, setData.AccountId)
	returnData.Account = GameAccountData.ReturnData(setData)

	_ = codeDatabase.DeleteData(&GameCodeData.Data{}, fmt.Sprintf("code_mail = %q", email))

	Utils.Success(c, returnData)
	return
}
