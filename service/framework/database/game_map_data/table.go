/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package GameMapData

import (
	"Service/framework/database"
)

var TableName = "game_map_data"

type Data struct {
	MapId       int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:map_id"`
	MapServerId int    `gorm:"column:map_server_id"`
	MapNumber   string `gorm:"column:map_number"`
	MapName     string `gorm:"column:map_name"`
	MapDefaultX int    `gorm:"column:map_default_x"`
	MapDefaultY int    `gorm:"column:map_default_y"`
	MapStatus   int    `gorm:"column:map_status"`
	Database.DefaultField
}

type Return struct {
	MapNumber   string `json:"map_number"`
	MapName     string `json:"map_name"`
	MapDefaultX int    `json:"map_default_x"`
	MapDefaultY int    `json:"map_default_y"`
}

func ReturnData(dataStruct *Data) Return {

	data := Return{}

	if dataStruct.MapId > 0 {
		data.MapNumber = dataStruct.MapNumber
		data.MapName = dataStruct.MapName
		data.MapDefaultX = dataStruct.MapDefaultX
		data.MapDefaultY = dataStruct.MapDefaultY
	}

	return data
}
