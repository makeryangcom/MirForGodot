/**
#*****************************************************************************
# @file    table.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package GameAccountData

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_account_data"

type Data struct {
	AccountId        int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:account_id"`
	AccountAccount   string `gorm:"column:account_account"`
	AccountPassword  string `gorm:"column:account_password"`
	AccountName      string `gorm:"column:account_name"`
	AccountNumber    string `gorm:"column:account_number"`
	AccountQuestionA string `gorm:"column:account_question_a"`
	AccountQuestionB string `gorm:"column:account_question_b"`
	AccountAnswerA   string `gorm:"column:account_answer_a"`
	AccountAnswerB   string `gorm:"column:account_answer_b"`
	AccountStatus    int    `gorm:"column:account_status"`
	Database.DefaultField
}

type Return struct {
	Token string `json:"token"`
}

func ReturnData(dataStruct *Data) Return {

	data := Return{}

	if dataStruct.AccountId > 0 {
		data.Token = Utils.EncodeId(32, dataStruct.AccountId)
	}

	return data
}
