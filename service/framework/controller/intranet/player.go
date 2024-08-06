/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package IntranetController

import (
	"Service/framework/database"
	"Service/framework/database/game_player_data"
	"Service/framework/utils"
	"fmt"
	"github.com/gin-gonic/gin"
	"strconv"
)

func PlayerUpdateClientId(c *gin.Context) {

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

	playerDatabase := Database.New(GamePlayerData.TableName)
	playerWhere := fmt.Sprintf("player_server_id = %d AND player_id = %d", playerId[2], playerId[0])
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
