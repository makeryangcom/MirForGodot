/**
 ******************************************************************************
 * @file    framework.go
 * @author  MakerYang
 ******************************************************************************
 */

package Framework

import (
	"Game/framework/config"
	"Game/framework/controller"
	"Game/framework/database"
)

func Init() {
	// 初始化配置
	Config.Init()
	// 初始化数据库
	Database.Init()
	// 初始化控制器
	Controller.Init()
}
