package GameCodeData

import (
	"Service/framework/database"
	"Service/framework/utils"
)

var TableName = "game_code_data"

type Data struct {
	CodeId      int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:code_id" json:"code_id"`
	CodePhone   string `gorm:"column:code_phone" json:"code_phone"`
	CodeMail    string `gorm:"column:code_mail" json:"code_mail"`
	CodeContent string `gorm:"column:code_content" json:"code_content"`
	Database.DefaultField
}

type ReturnData struct {
	Token       string `json:"token"`
	CodeId      int    `json:"code_id"`
	CodePhone   string `json:"code_phone"`
	CodeMail    string `json:"code_mail"`
	CodeContent string `json:"code_content"`
}

func FormatData(dataStruct *Data) ReturnData {

	data := ReturnData{}

	if dataStruct.CodeId > 0 {
		data.Token = Utils.EncodeId(32, dataStruct.CodeId, 1)
		data.CodeContent = dataStruct.CodeContent
	}

	return data
}
