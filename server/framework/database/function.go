/**
#*****************************************************************************
# @file    function.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Database

import (
	"github.com/jinzhu/gorm"
	"time"
)

// Base 声明数据库基础数据结构体
type Base struct {
	TableName string
}

// New 实例化数据表
func New(table string) *Base {
	return &Base{
		TableName: table,
	}
}

// CreateData 创建数据
func (base *Base) CreateData(data interface{}) error {
	err := Get.Table(base.TableName).Create(data).Error
	return err
}

// UpdateData 更新数据
func (base *Base) UpdateData(query interface{}, data map[string]interface{}) error {
	data["update_at"] = time.Now().Unix()
	err := Get.Table(base.TableName).Where(query).Updates(data).Error
	return err
}

// ExprData 更新数值类字段值
func (base *Base) ExprData(query interface{}, field string, operation string, data int) error {
	err := Get.Table(base.TableName).Where(query).Update(field, gorm.Expr(field+" "+operation+" ?", data)).Error
	return err
}

// GetData 读取一条数据
func (base *Base) GetData(dataStruct interface{}, query interface{}, order string) error {
	err := Get.Table(base.TableName).Where(query).Order(order).First(dataStruct).Error
	return err
}

// ListData 读取多条数据
func (base *Base) ListData(dataStruct interface{}, query interface{}, order string, limit int) error {
	err := Get.Table(base.TableName).Where(query).Order(order).Limit(limit).Find(dataStruct).Error
	return err
}

// PageData 读取分页数据
func (base *Base) PageData(dataStruct interface{}, query interface{}, order string, limit int, page int) error {
	err := Get.Table(base.TableName).Where(query).Order(order).Limit(limit).Offset(page * limit).Find(dataStruct).Error
	return err
}

// CountData 获取数据总数
func (base *Base) CountData(query interface{}) (int, error) {
	count := 0
	err := Get.Table(base.TableName).Where(query).Count(&count).Error
	return count, err
}

// DeleteData 删除数据
func (base *Base) DeleteData(dataStruct interface{}, query interface{}) error {
	err := Get.Table(base.TableName).Where(query).Delete(dataStruct).Error
	return err
}
