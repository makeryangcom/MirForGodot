/**
#*****************************************************************************
# @file    config.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Config

import "time"

// Get 定义系统配置模块的调用指针
var Get = &config{}

// 声明系统配置模块数据结构体
type config struct {
	Service  service  `json:"service"`
	Database database `json:"database"`
	Hash     hash     `json:"hash"`
}

// 声明系统配置模块的服务器配置数据结构体
type service struct {
	Mode         string        `json:"mode"`
	HttpPort     int           `json:"http_port"`
	ReadTimeout  time.Duration `json:"read_timeout"`
	WriteTimeout time.Duration `json:"write_timeout"`
}

// 声明系统配置模块的数据库配置数据结构体
type database struct {
	Type     string `json:"type"`
	User     string `json:"user"`
	Password string `json:"password"`
	Host     string `json:"host"`
	Name     string `json:"name"`
}

// 声明系统配置模块的HASH加密配置数据结构体
type hash struct {
	Salt string `json:"salt"`
}

// Init 初始化系统配置
func Init() {

	Get.Service.Mode = "debug"
	Get.Service.HttpPort = 7000
	Get.Service.ReadTimeout = 60 * time.Second
	Get.Service.WriteTimeout = 60 * time.Second

	Get.Database.Name = "database"
	Get.Database.Type = "mysql"
	Get.Database.Host = "localhost"
	Get.Database.User = "root"
	Get.Database.Password = "88888888"

	Get.Hash.Salt = "game_$@#godot_@$salt_$@$service%#^#%@%#"
}
