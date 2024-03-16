/**
#*****************************************************************************
# @file    table.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package GamePlayerData

import (
	"Game/framework/database"
	"Game/framework/utils"
)

var TableName = "game_player_data"

type Data struct {
	PlayerId              int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:player_id"`
	PlayerAccountId       int    `gorm:"column:player_account_id"`
	PlayerServerId        int    `gorm:"column:player_server_id"`
	PlayerNickname        string `gorm:"column:player_nickname"`
	PlayerCareer          string `gorm:"column:player_career"`
	PlayerGender          string `gorm:"column:player_gender"`
	PlayerAngle           int    `gorm:"column:player_angle"`
	PlayerMap             string `gorm:"column:player_map"`
	PlayerMapX            int    `gorm:"column:player_map_x"`
	PlayerMapY            int    `gorm:"column:player_map_y"`
	PlayerAssetLife       int    `gorm:"column:player_asset_life"`
	PlayerAssetMagic      int    `gorm:"column:player_asset_magic"`
	PlayerAssetExperience int    `gorm:"column:player_asset_experience"`
	PlayerBodyClothe      string `gorm:"column:player_body_clothe"`
	PlayerBodyWeapon      string `gorm:"column:player_body_weapon"`
	PlayerBodyWing        string `gorm:"column:player_body_wing"`
	PlayerGroupId         int    `gorm:"column:player_group_id"`
	PlayerStatus          int    `gorm:"column:player_status"`
	Database.DefaultField
}

type Return struct {
	Token                 string `json:"token"`
	PlayerNickname        string `json:"player_nickname"`
	PlayerCareer          string `json:"player_career"`
	PlayerGender          string `json:"player_gender"`
	PlayerAngle           int    `json:"player_angle"`
	PlayerMap             string `json:"player_map"`
	PlayerMapX            int    `json:"player_map_x"`
	PlayerMapY            int    `json:"player_map_y"`
	PlayerAssetLife       int    `json:"player_asset_life"`
	PlayerAssetMagic      int    `json:"player_asset_magic"`
	PlayerAssetExperience int    `json:"player_asset_experience"`
	PlayerBodyClothe      string `json:"player_body_clothe"`
	PlayerBodyWeapon      string `json:"player_body_weapon"`
	PlayerBodyWing        string `json:"player_body_wing"`
	PlayerGroupId         int    `json:"player_group_id"`
}

func ReturnData(dataStruct *Data) Return {

	data := Return{}

	if dataStruct.PlayerId > 0 {
		data.Token = Utils.EncodeId(32, dataStruct.PlayerId, dataStruct.PlayerAccountId, dataStruct.PlayerServerId)
		data.PlayerNickname = dataStruct.PlayerNickname
		data.PlayerCareer = dataStruct.PlayerCareer
		data.PlayerGender = dataStruct.PlayerGender
		data.PlayerAngle = dataStruct.PlayerAngle
		data.PlayerMap = dataStruct.PlayerMap
		data.PlayerMapX = dataStruct.PlayerMapX
		data.PlayerMapY = dataStruct.PlayerMapY
		data.PlayerAssetLife = dataStruct.PlayerAssetLife
		data.PlayerAssetMagic = dataStruct.PlayerAssetMagic
		data.PlayerAssetExperience = dataStruct.PlayerAssetExperience
		data.PlayerBodyClothe = dataStruct.PlayerBodyClothe
		data.PlayerBodyWeapon = dataStruct.PlayerBodyWeapon
		data.PlayerBodyWing = dataStruct.PlayerBodyWing
		data.PlayerGroupId = dataStruct.PlayerGroupId
	}

	return data
}
