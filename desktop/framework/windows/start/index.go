/**
 ******************************************************************************
 * @file    index.go
 * @author  MakerYang
 ******************************************************************************
 */

package StartWindows

import (
	"cnc/framework/config"
	"context"
	"os"
	"runtime"
	"strings"
)

type Api struct {
	ctx context.Context
}

type ReturnResponse struct {
	Code int         `json:"code"`
	Data interface{} `json:"data"`
	Msg  string      `json:"msg"`
}

func Init() *Api {
	return &Api{}
}

func (start *Api) Startup(ctx context.Context) {
	start.ctx = ctx
}

func (start *Api) Shutdown(ctx context.Context) {

}

func (start *Api) GetPlatform() string {
	platform := ""
	switch runtime.GOOS {
	case "windows":
		platform = "Windows"
	case "darwin":
		platform = "Darwin"
	case "linux":
		platform = "Linux"
		content, err := os.ReadFile("/etc/os-release")
		if err == nil {
			lines := strings.Split(string(content), "\n")
			for _, line := range lines {
				if strings.HasPrefix(line, "ID=") {
					switch {
					case strings.Contains(line, "ubuntu"):
						platform = "Ubuntu"
					case strings.Contains(line, "debian"):
						platform = "Debian"
					default:
						platform = "Linux"
					}
				}
			}
		}
	default:
		platform = "-"
	}

	return platform
}

func (start *Api) GetVersion() []string {
	return []string{Config.Get.Info.ProductName, Config.Get.Info.ProductVersion}
}
