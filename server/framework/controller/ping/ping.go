/**
 ******************************************************************************
 * @file    ping.go
 * @author  MakerYang
 ******************************************************************************
 */

package PingController

import (
	"Game/framework/utils"
	"github.com/gin-gonic/gin"
)

func Ping(c *gin.Context) {
	Utils.Success(c, Utils.EmptyData{})
	return
}
