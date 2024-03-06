/**
#*****************************************************************************
# @file    interface.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Interface

import (
	"Game/framework/config"
	"Game/framework/interface/ping"
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gookit/color"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"
)

// 接口路由
func router() *gin.Engine {

	router := gin.New()

	gin.SetMode(Config.Get.Service.Mode)

	// 健康检查接口
	router.GET("/ping", PingInterface.Ping)

	return router
}

// Init 接口初始化
func Init() {

	routers := router()

	var HttpServer = &http.Server{
		Addr:           fmt.Sprintf(":%d", Config.Get.Service.HttpPort),
		Handler:        routers,
		ReadTimeout:    Config.Get.Service.ReadTimeout,
		WriteTimeout:   Config.Get.Service.WriteTimeout,
		MaxHeaderBytes: 1 << 20,
	}

	go func() {
		if err := HttpServer.ListenAndServe(); err != nil {
		}
	}()

	log.Println("[game]", color.Green.Text("server..."))

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := HttpServer.Shutdown(ctx); err != nil {
	}
}
