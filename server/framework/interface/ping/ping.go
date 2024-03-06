/**
#*****************************************************************************
# @file    ping.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package PingInterface

import (
	"Game/framework/utils"
	"github.com/gin-gonic/gin"
)

// Ping 健康检查接口
func Ping(c *gin.Context) {

	Utils.Success(c, Utils.Empty{})
	return
}
