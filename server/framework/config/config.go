/**
 ******************************************************************************
 * @file    config.go
 * @author  MakerYang
 ******************************************************************************
 */

package Config

import "time"

var Get = &config{}

type config struct {
	Service  service  `json:"service"`
	Database database `json:"database"`
	Hash     hash     `json:"hash"`
}

type service struct {
	Mode         string        `json:"mode"`
	HttpPort     int           `json:"http_port"`
	ReadTimeout  time.Duration `json:"read_timeout"`
	WriteTimeout time.Duration `json:"write_timeout"`
}

type database struct {
	Type     string `json:"type"`
	User     string `json:"user"`
	Password string `json:"password"`
	Host     string `json:"host"`
	Name     string `json:"name"`
}

type hash struct {
	Salt string `json:"salt"`
}

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
