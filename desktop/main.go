/**
 ******************************************************************************
 * @file    main.go
 * @author  Makeryang
 ******************************************************************************
 */

package main

import (
	"cnc/framework"
	"embed"
	"fmt"
	"github.com/gookit/color"
)

//go:embed all:template/dist
var Template embed.FS

//go:embed all:wails.json
var VersionInfo embed.FS

func main() {
	fmt.Println("[desktop][main]：" + color.Gray.Text("starting..."))
	Framework.Init(Template, VersionInfo)
}
