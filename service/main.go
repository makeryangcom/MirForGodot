/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package main

import (
	"Service/framework"
	"Service/framework/config"
	"Service/framework/router"
	"context"
	"fmt"
	"github.com/gookit/color"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"
)

func init() {
	Framework.Init()
}

func main() {

	// 设置log的Flag为0，移除所有前缀（包括时间）
	log.SetFlags(0)

	RouterInit := Router.Init()

	var HttpServer = &http.Server{
		Addr:           fmt.Sprintf(":%d", Config.Get.Service.HttpPort),
		Handler:        RouterInit,
		ReadTimeout:    Config.Get.Service.ReadTimeout,
		WriteTimeout:   Config.Get.Service.WriteTimeout,
		MaxHeaderBytes: 1 << 20,
	}

	go func() {
		if err := HttpServer.ListenAndServe(); err != nil {
		}
	}()

	log.Println("[main]", color.Green.Text("server..."))

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := HttpServer.Shutdown(ctx); err != nil {
	}
}
