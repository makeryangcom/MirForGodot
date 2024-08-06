/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package GameController

import (
	"Service/framework/database"
	"Service/framework/database/game_server_data"
	"Service/framework/utils"
	"fmt"
	"github.com/gin-gonic/gin"
)

type responseServerIndex struct {
	Server []GameServerData.Return `json:"server"`
}

func ServerIndex(c *gin.Context) {

	returnData := responseServerIndex{}
	returnData.Server = make([]GameServerData.Return, 0)

	referer, uid := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	if uid == 0 {
		Utils.Warning(c, -1, "登录失效，请重新登录", Utils.EmptyData{})
		return
	}

	serverDatabase := Database.New(GameServerData.TableName)
	serverList := make([]GameServerData.Data, 0)
	serverWhere := fmt.Sprintf("server_status = %d", 2)
	err := serverDatabase.ListData(&serverList, serverWhere, "server_id", 10)
	if err == nil {
		for _, v := range serverList {
			item := GameServerData.ReturnData(&v)
			returnData.Server = append(returnData.Server, item)
		}
	}

	Utils.Success(c, returnData)
	return
}
