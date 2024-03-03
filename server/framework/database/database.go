/**
 ******************************************************************************
 * @file    database.go
 * @author  MakerYang
 ******************************************************************************
 */

package Database

import (
	"Game/framework/config"
	"fmt"
	"github.com/gookit/color"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"log"
	"time"
)

var Get *gorm.DB

type DefaultField struct {
	CreateAt int `gorm:"Column:create_at" json:"create_at"`
	UpdateAt int `gorm:"Column:update_at" json:"update_at"`
	DeleteAt int `gorm:"Column:delete_at" json:"delete_at"`
}

func Init() {

	var err error

	Get, err = gorm.Open(Config.Get.Database.Type, fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8mb4&parseTime=True&loc=Local", Config.Get.Database.User, Config.Get.Database.Password, Config.Get.Database.Host, Config.Get.Database.Name))
	if err != nil {
		log.Println("[database]", color.Red.Text(err.Error()))
	}

	if Config.Get.Service.Mode == "release" {
		Get.LogMode(false)
	} else {
		Get.LogMode(true)
	}

	gorm.DefaultTableNameHandler = func(db *gorm.DB, defaultTableName string) string {
		return defaultTableName
	}

	Get.SingularTable(true)

	Get.Callback().Create().Replace("gorm:update_time_stamp", func(scope *gorm.Scope) {
		if !scope.HasError() {
			nowTime := time.Now().Unix()
			if createTimeField, ok := scope.FieldByName("CreateAt"); ok {
				if createTimeField.IsBlank {
					err := createTimeField.Set(nowTime)
					if err != nil {
					}
				}
			}

			if modifyTimeField, ok := scope.FieldByName("UpdateAt"); ok {
				if modifyTimeField.IsBlank {
					err := modifyTimeField.Set(nowTime)
					if err != nil {
					}
				}
			}
		}
	})

	Get.DB().SetMaxIdleConns(1000)
	Get.DB().SetMaxOpenConns(10000)

	Get.DB().SetConnMaxLifetime(time.Second * 45)
}
