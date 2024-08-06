/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package PingController

import (
	"Service/framework/utils"
	"github.com/gin-gonic/gin"
)

func Ping(c *gin.Context) {

	referer, _ := Utils.CheckHeader(c)
	if !referer {
		Utils.Error(c, Utils.EmptyData{})
		return
	}

	Utils.Success(c, Utils.EmptyData{})
	return
}
