/**
 ******************************************************************************
 * @file    controller.go
 * @author  MakerYang
 ******************************************************************************
 */

package Controller

import (
	"Game/framework/config"
	"Game/framework/controller/ping"
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

func router() *gin.Engine {
	router := gin.New()

	gin.SetMode(Config.Get.Service.Mode)

	router.GET("/ping", PingController.Ping)

	return router
}

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
