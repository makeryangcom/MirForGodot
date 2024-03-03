/**
 ******************************************************************************
 * @file    framework.go
 * @author  MakerYang
 ******************************************************************************
 */

package Framework

import (
	"cnc/framework/config"
	"cnc/framework/windows/start"
	"embed"
	"fmt"
	"github.com/gookit/color"
	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
	"github.com/wailsapp/wails/v2/pkg/options/linux"
	"github.com/wailsapp/wails/v2/pkg/options/windows"
)

func Init(template embed.FS, version embed.FS) {

	Config.Init(version)

	start := StartWindows.Init()

	err := wails.Run(&options.App{
		Title:     "",
		Width:     1200,
		Height:    768,
		MinWidth:  1200,
		MinHeight: 768,
		AssetServer: &assetserver.Options{
			Assets: template,
		},
		BackgroundColour: &options.RGBA{R: 255, G: 255, B: 255, A: 1},
		OnStartup:        start.Startup,
		OnShutdown:       start.Shutdown,
		Bind: []interface{}{
			start,
		},
		WindowStartState: options.Normal,
		Windows: &windows.Options{
			WebviewDisableRendererCodeIntegrity: true,
			DisableWindowIcon:                   true,
		},
		Linux: &linux.Options{
			Icon:                []byte(""),
			WindowIsTranslucent: false,
			WebviewGpuPolicy:    linux.WebviewGpuPolicyNever,
		},
		Debug: options.Debug{
			OpenInspectorOnStartup: false,
		},
	})

	if err != nil {
		fmt.Println("[desktop][framework]：" + color.Gray.Text(err.Error()))
	}
}
