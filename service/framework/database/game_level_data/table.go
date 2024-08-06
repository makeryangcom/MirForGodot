/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package GameLevelData

import (
	"Service/framework/database"
)

var TableName = "game_level_data"

type Data struct {
	LevelId         int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:level_id"`
	LevelServerId   int    `gorm:"column:level_server_id"`
	LevelCareer     string `gorm:"column:level_career"`
	LevelName       int    `gorm:"column:level_name"`
	LevelMin        int    `gorm:"column:level_min"`
	LevelMax        int    `gorm:"column:level_max"`
	LevelLifeValue  int    `gorm:"column:level_life_value"`
	LevelMagicValue int    `gorm:"column:level_magic_value"`
	LevelStatus     int    `gorm:"column:level_status"`
	Database.DefaultField
}

type Return struct {
	LevelCareer     string `json:"level_career"`
	LevelName       int    `json:"level_name"`
	LevelMin        int    `json:"level_min"`
	LevelMax        int    `json:"level_max"`
	LevelLifeValue  int    `json:"level_life_value"`
	LevelMagicValue int    `json:"level_magic_value"`
}

func ReturnData(dataStruct *Data) Return {

	data := Return{}

	if dataStruct.LevelId > 0 {
		data.LevelCareer = dataStruct.LevelCareer
		data.LevelName = dataStruct.LevelName
		data.LevelMin = dataStruct.LevelMin
		data.LevelMax = dataStruct.LevelMax
		data.LevelLifeValue = dataStruct.LevelLifeValue
		data.LevelMagicValue = dataStruct.LevelMagicValue
	}

	return data
}
