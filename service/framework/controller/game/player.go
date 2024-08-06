/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package GameController

import (
	"Service/framework/database"
	"Service/framework/database/game_level_data"
	"Service/framework/database/game_map_data"
	"Service/framework/database/game_player_data"
	"Service/framework/utils"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"strconv"
)

type responsePlayerIndex struct {
	Player []GamePlayerData.Return `json:"player"`
}

func PlayerIndex(c *gin.Context) {

	returnData := responsePlayerIndex{}
	returnData.Player = make([]GamePlayerData.Return, 0)

	referer, uid := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	if uid == 0 {
		Utils.Warning(c, -1, "登录失效，请重新登录", Utils.EmptyData{})
		return
	}

	token := c.DefaultQuery("token", "")
	if token == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	serverId, _ := Utils.DecodeId(32, token)
	if len(serverId) != 1 {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	roleDatabase := Database.New(GamePlayerData.TableName)
	roleList := make([]GamePlayerData.Data, 0)
	roleWhere := fmt.Sprintf("player_status = %d AND player_account_id = %d AND player_server_id = %d", 2, uid, serverId[0])
	err := roleDatabase.ListData(&roleList, roleWhere, "player_id DESC", 6)
	if err == nil {
		for _, v := range roleList {
			item := GamePlayerData.ReturnData(&v)
			// 地图数据查询
			mapDatabase := Database.New(GameMapData.TableName)
			mapData := GameMapData.Data{}
			mapWhere := fmt.Sprintf("map_number = %q", item.PlayerMap)
			err := mapDatabase.GetData(&mapData, mapWhere, "")
			if err == nil {
				if item.PlayerMapX == 0 || item.PlayerMapY == 0 {
					item.PlayerMapName = mapData.MapName
					item.PlayerMapX = mapData.MapDefaultX
					item.PlayerMapY = mapData.MapDefaultY
				}
			}
			// 等级数据查询
			levelDatabase := Database.New(GameLevelData.TableName)
			levelData := GameLevelData.Data{}
			levelWhere := fmt.Sprintf("level_career = %q AND (level_min >= %d AND level_max > %d)", item.PlayerCareer, item.PlayerAssetExperience, item.PlayerAssetExperience)
			err = levelDatabase.GetData(&levelData, levelWhere, "")
			if err == nil {
				item.PlayerAssetLevel = levelData.LevelName
				item.PlayerAssetLifeMax = levelData.LevelLifeValue
				item.PlayerAssetMagicMax = levelData.LevelMagicValue
				item.PlayerAssetExperienceMax = levelData.LevelMax

			}
			returnData.Player = append(returnData.Player, item)
		}
	}

	Utils.Success(c, returnData)
	return
}

type requestPlayerCreate struct {
	Token    string `json:"token"`
	Nickname string `json:"nickname"`
	Gender   string `json:"gender"`
	Career   string `json:"career"`
}

type responsePlayerCreate struct {
	Player GamePlayerData.Return `json:"player"`
}

func PlayerCreate(c *gin.Context) {

	returnData := responsePlayerCreate{}

	referer, uid := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	if uid == 0 {
		Utils.Warning(c, -1, "登录失效，请重新登录", Utils.EmptyData{})
		return
	}

	jsonData := requestPlayerCreate{}
	requestJson, _ := ioutil.ReadAll(c.Request.Body)
	fmt.Println(string(requestJson))
	err := json.Unmarshal(requestJson, &jsonData)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	serverId, _ := Utils.DecodeId(32, jsonData.Token)
	if len(serverId) != 1 {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	playerDatabase := Database.New(GamePlayerData.TableName)
	playerData := GamePlayerData.Data{}
	playerWhere := fmt.Sprintf("player_account_id = %d AND player_server_id = %d AND player_nickname = %q", uid, serverId[0], jsonData.Nickname)
	err = playerDatabase.GetData(&playerData, playerWhere, "")
	if err == nil {
		Utils.Warning(c, 10000, "昵称已经被占用，请换一个", Utils.EmptyData{})
		return
	}

	clothe := "000"
	weapon := "000"
	wing := "000"

	if jsonData.Career == "warrior" {
		clothe = "009"
		weapon = "034"
		wing = "010"
	}

	if jsonData.Career == "mage" {
		clothe = "009"
		weapon = "035"
		wing = "010"
	}

	if jsonData.Career == "taoist" {
		clothe = "009"
		weapon = "036"
		wing = "010"
	}

	setData := &GamePlayerData.Data{}
	setData.PlayerAccountId = uid
	setData.PlayerServerId = serverId[0]
	setData.PlayerNickname = jsonData.Nickname
	setData.PlayerCareer = jsonData.Career
	setData.PlayerGender = jsonData.Gender
	setData.PlayerBalance = 100
	setData.PlayerIntegral = 10
	setData.PlayerAngle = 2
	setData.PlayerMap = "001"
	setData.PlayerMapX = 0
	setData.PlayerMapY = 0
	setData.PlayerAssetLife = 1
	setData.PlayerAssetMagic = 1
	setData.PlayerAssetExperience = 1
	setData.PlayerBodyClothe = clothe
	setData.PlayerBodyWeapon = weapon
	setData.PlayerBodyWing = wing
	setData.PlayerGroupId = 1
	setData.PlayerStatus = 2
	err = playerDatabase.CreateData(setData)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	returnData.Player = GamePlayerData.ReturnData(setData)

	// 地图数据查询
	mapDatabase := Database.New(GameMapData.TableName)
	mapData := GameMapData.Data{}
	mapWhere := fmt.Sprintf("map_number = %q", returnData.Player.PlayerMap)
	err = mapDatabase.GetData(&mapData, mapWhere, "")
	if err == nil {
		if returnData.Player.PlayerMapX == 0 || returnData.Player.PlayerMapY == 0 {
			returnData.Player.PlayerMapName = mapData.MapName
			returnData.Player.PlayerMapX = mapData.MapDefaultX
			returnData.Player.PlayerMapY = mapData.MapDefaultY
		}
	}

	// 等级数据查询
	levelDatabase := Database.New(GameLevelData.TableName)
	levelData := GameLevelData.Data{}
	levelWhere := fmt.Sprintf("level_career = %q AND (level_min >= %d AND level_max > %d)", returnData.Player.PlayerCareer, returnData.Player.PlayerAssetExperience, returnData.Player.PlayerAssetExperience)
	err = levelDatabase.GetData(&levelData, levelWhere, "")
	if err == nil {
		returnData.Player.PlayerAssetLevel = levelData.LevelName
		returnData.Player.PlayerAssetLifeMax = levelData.LevelLifeValue
		returnData.Player.PlayerAssetMagicMax = levelData.LevelMagicValue
		returnData.Player.PlayerAssetExperienceMax = levelData.LevelMax
	}

	Utils.Success(c, returnData)
	return
}

func PlayerUpdateClientId(c *gin.Context) {

	referer, uid := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	clientId := c.DefaultQuery("client_id", "")
	if clientId == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	token := c.DefaultQuery("token", "")
	if token == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	playerId, _ := Utils.DecodeId(32, token)
	if len(playerId) != 3 {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	if uid == 0 {
		Utils.Warning(c, -1, "登录失效，请重新登录", Utils.EmptyData{})
		return
	}

	playerDatabase := Database.New(GamePlayerData.TableName)
	playerWhere := fmt.Sprintf("player_account_id = %d AND player_server_id = %d AND player_id = %d", uid, playerId[2], playerId[0])
	clientIdInt, _ := strconv.Atoi(clientId)
	update := map[string]interface{}{"player_client_id": clientIdInt}
	err := playerDatabase.UpdateData(playerWhere, update)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}

func PlayerDelete(c *gin.Context) {

	referer, uid := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	if uid == 0 {
		Utils.Warning(c, -1, "登录失效，请重新登录", Utils.EmptyData{})
		return
	}

	token := c.DefaultQuery("token", "")
	if token == "" {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	playerId, _ := Utils.DecodeId(32, token)
	if len(playerId) != 3 {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	playerDatabase := Database.New(GamePlayerData.TableName)
	playerWhere := fmt.Sprintf("player_account_id = %d AND player_server_id = %d AND player_id = %d", uid, playerId[2], playerId[0])
	update := map[string]interface{}{"player_status": 1}
	err := playerDatabase.UpdateData(playerWhere, update)
	if err != nil {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}
