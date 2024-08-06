/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package GamePlayerData

import (
	"Service/framework/database"
	"Service/framework/utils"
)

var TableName = "game_player_data"

type Data struct {
	PlayerId              int    `gorm:"primary_key;AUTO_INCREMENT;unique_index;not null;column:player_id"`
	PlayerAccountId       int    `gorm:"column:player_account_id"`
	PlayerServerId        int    `gorm:"column:player_server_id"`
	PlayerNickname        string `gorm:"column:player_nickname"`
	PlayerCareer          string `gorm:"column:player_career"`
	PlayerGender          string `gorm:"column:player_gender"`
	PlayerBalance         int    `gorm:"column:player_balance"`
	PlayerIntegral        int    `gorm:"column:player_integral"`
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
	PlayerClientId        int    `gorm:"column:player_client_id"`
	PlayerGroupId         int    `gorm:"column:player_group_id"`
	PlayerStatus          int    `gorm:"column:player_status"`
	Database.DefaultField
}

type Return struct {
	Token                    string `json:"token"`
	PlayerNickname           string `json:"player_nickname"`
	PlayerCareer             string `json:"player_career"`
	PlayerGender             string `json:"player_gender"`
	PlayerBalance            string `json:"player_balance"`
	PlayerIntegral           string `json:"player_integral"`
	PlayerAngle              int    `json:"player_angle"`
	PlayerMap                string `json:"player_map"`
	PlayerMapName            string `json:"player_map_name"`
	PlayerMapX               int    `json:"player_map_x"`
	PlayerMapY               int    `json:"player_map_y"`
	PlayerAssetLevel         int    `json:"player_asset_level"`
	PlayerAssetLife          int    `json:"player_asset_life"`
	PlayerAssetLifeMax       int    `json:"player_asset_life_max"`
	PlayerAssetMagic         int    `json:"player_asset_magic"`
	PlayerAssetMagicMax      int    `json:"player_asset_magic_max"`
	PlayerAssetWeight        int    `json:"player_asset_weight"`
	PlayerAssetWeightMax     int    `json:"player_asset_weight_max"`
	PlayerAssetExperience    int    `json:"player_asset_experience"`
	PlayerAssetExperienceMax int    `json:"player_asset_experience_max"`
	PlayerBodyClothe         string `json:"player_body_clothe"`
	PlayerBodyWeapon         string `json:"player_body_weapon"`
	PlayerBodyWing           string `json:"player_body_wing"`
	PlayerClientId           int    `json:"player_client_id"`
	PlayerGroupId            int    `json:"player_group_id"`
}

func ReturnData(dataStruct *Data) Return {

	data := Return{}

	if dataStruct.PlayerId > 0 {
		data.Token = Utils.EncodeId(32, dataStruct.PlayerId, dataStruct.PlayerAccountId, dataStruct.PlayerServerId)
		data.PlayerNickname = dataStruct.PlayerNickname
		data.PlayerCareer = dataStruct.PlayerCareer
		data.PlayerGender = dataStruct.PlayerGender
		data.PlayerBalance = Utils.FormatCurrency(dataStruct.PlayerBalance)
		data.PlayerIntegral = Utils.FormatCurrency(dataStruct.PlayerIntegral)
		data.PlayerAngle = dataStruct.PlayerAngle
		data.PlayerMap = dataStruct.PlayerMap
		data.PlayerMapX = dataStruct.PlayerMapX
		data.PlayerMapY = dataStruct.PlayerMapY
		data.PlayerAssetLevel = 0
		data.PlayerAssetLife = dataStruct.PlayerAssetLife
		data.PlayerAssetLifeMax = 0
		data.PlayerAssetMagic = dataStruct.PlayerAssetMagic
		data.PlayerAssetMagicMax = 0
		data.PlayerAssetWeight = 5
		data.PlayerAssetWeightMax = 50
		data.PlayerAssetExperience = dataStruct.PlayerAssetExperience
		data.PlayerAssetExperienceMax = 0
		data.PlayerBodyClothe = dataStruct.PlayerBodyClothe
		data.PlayerBodyWeapon = dataStruct.PlayerBodyWeapon
		data.PlayerBodyWing = dataStruct.PlayerBodyWing
		data.PlayerClientId = dataStruct.PlayerClientId
		data.PlayerGroupId = dataStruct.PlayerGroupId
	}

	return data
}
