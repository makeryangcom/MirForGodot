/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package IntranetController

import (
	"Service/framework/database"
	"Service/framework/database/game_map_data"
	"Service/framework/utils"
	"fmt"
	"github.com/gin-gonic/gin"
)

type responseMapList struct {
	Map []GameMapData.Return `json:"map"`
}

func MapList(c *gin.Context) {

	returnData := responseMapList{}
	returnData.Map = make([]GameMapData.Return, 0)

	mapDatabase := Database.New(GameMapData.TableName)
	mapList := make([]GameMapData.Data, 0)
	mapWhere := fmt.Sprintf("map_status = %d", 2)
	err := mapDatabase.ListData(&mapList, mapWhere, "map_id", 1000)
	if err == nil {
		for _, v := range mapList {
			item := GameMapData.ReturnData(&v)
			returnData.Map = append(returnData.Map, item)
		}
	}

	Utils.Success(c, returnData)
	return
}
