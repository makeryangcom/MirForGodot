/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Router

import (
	"Service/framework/config"
	"Service/framework/controller/disktop"
	"Service/framework/controller/game"
	"Service/framework/controller/intranet"
	"Service/framework/controller/ping"
	"github.com/gin-gonic/gin"
)

func Init() *gin.Engine {

	router := gin.New()

	gin.SetMode(Config.Get.Service.Mode)

	ping := router.Group("ping")
	{
		ping.GET("/index", PingController.Ping)
	}

	internal := router.Group("internal")
	{
		internal.GET("/message/index", IntranetController.MessageIndex)

		internal.GET("/map/list", IntranetController.MapList)

		internal.GET("/player/update/client/id", IntranetController.PlayerUpdateClientId)
	}

	desktop := router.Group("desktop")
	{
		desktop.GET("/check/index", DisktopController.CheckIndex)

		desktop.GET("/index/mail/code", DisktopController.MailCode)

		desktop.GET("/index/mail/register", DisktopController.MailRegister)

		desktop.GET("/index/mail/login", DisktopController.MailLogin)
	}

	game := router.Group("game")
	{
		game.GET("/account/mail/code", GameController.MailCode)

		game.GET("/account/mail/login", GameController.MailLogin)

		game.POST("/account/mail/register", GameController.MailRegister)

		game.POST("/account/mail/change/password", GameController.MailChangePassword)

		game.GET("/server/index", GameController.ServerIndex)

		game.GET("/player/index", GameController.PlayerIndex)

		game.POST("/player/create", GameController.PlayerCreate)

		game.GET("/player/update/client/id", GameController.PlayerUpdateClientId)

		game.GET("/player/delete", GameController.PlayerDelete)
	}

	return router
}
