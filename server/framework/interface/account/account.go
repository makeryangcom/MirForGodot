/**
#*****************************************************************************
# @file    account.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package AccountInterface

import (
	"Game/framework/database"
	"Game/framework/database/game_account_data"
	"Game/framework/utils"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
)

type requestRegister struct {
	Account   string `json:"account"`
	Password  string `json:"password"`
	Name      string `json:"name"`
	Number    string `json:"number"`
	QuestionA string `json:"question_a"`
	AnswerA   string `json:"answer_a"`
	QuestionB string `json:"question_b"`
	AnswerB   string `json:"answer_b"`
}

type responseRegister struct {
	Token string `json:"token"`
}

func Register(c *gin.Context) {

	returnData := responseRegister{}

	jsonData := requestRegister{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Error(c, returnData)
		return
	}

	accountDatabase := Database.New(GameAccountData.TableName)
	accountData := GameAccountData.Data{}
	where := fmt.Sprintf("account_account = %q", jsonData.Account)
	err = accountDatabase.GetData(&accountData, where, "")
	if err == nil && accountData.AccountId > 0 {
		Utils.Warning(c, 10001, "邮箱已经被注册", returnData)
		return
	}

	setData := &GameAccountData.Data{}
	setData.AccountAccount = jsonData.Account
	setData.AccountPassword = Utils.MD5Hash(jsonData.Password)
	setData.AccountName = jsonData.Name
	setData.AccountNumber = jsonData.Number
	setData.AccountQuestionA = jsonData.QuestionA
	setData.AccountAnswerA = jsonData.AnswerA
	setData.AccountQuestionB = jsonData.QuestionB
	setData.AccountAnswerB = jsonData.AnswerB
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

	returnData.Token = Utils.EncodeId(128, setData.AccountId)

	Utils.Success(c, returnData)
	return
}
