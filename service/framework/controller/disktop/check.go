package DisktopController

import (
	"Service/framework/database"
	"Service/framework/database/game_account_data"
	"Service/framework/utils"
	"fmt"
	"github.com/gin-gonic/gin"
)

type responseCheckIndex struct {
	Account GameAccountData.Return `json:"account"`
}

func CheckIndex(c *gin.Context) {

	returnData := responseCheckIndex{}

	referer, uid := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	if uid > 0 {
		accountDatabase := Database.New(GameAccountData.TableName)
		accountData := GameAccountData.Data{}
		accountWhere := fmt.Sprintf("account_id = %d", uid)
		err := accountDatabase.GetData(&accountData, accountWhere, "account_id DESC")
		if err == nil {
			returnData.Account = GameAccountData.ReturnData(&accountData)
		}
	}

	Utils.Success(c, returnData)
	return
}
