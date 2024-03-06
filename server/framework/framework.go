/**
#*****************************************************************************
# @file    framework.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Framework

import (
	"Game/framework/config"
	"Game/framework/database"
	"Game/framework/interface"
)

func Init() {
	// 初始化配置
	Config.Init()
	// 初始化数据库
	Database.Init()
	// 初始化接口路由
	Interface.Init()
}
