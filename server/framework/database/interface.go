/**
 ******************************************************************************
 * @file    interface.go
 * @author  MakerYang
 ******************************************************************************
 */

package Database

import (
	"github.com/jinzhu/gorm"
	"time"
)

type Base struct {
	TableName string
}

func New(table string) *Base {
	return &Base{
		TableName: table,
	}
}

func (base *Base) CreateData(data interface{}) error {
	err := Get.Table(base.TableName).Create(data).Error
	return err
}

func (base *Base) UpdateData(query interface{}, data map[string]interface{}) error {
	data["update_at"] = time.Now().Unix()
	err := Get.Table(base.TableName).Where(query).Updates(data).Error
	return err
}

func (base *Base) ExprData(query interface{}, field string, operation string, data int) error {
	err := Get.Table(base.TableName).Where(query).Update(field, gorm.Expr(field+" "+operation+" ?", data)).Error
	return err
}

func (base *Base) GetData(dataStruct interface{}, query interface{}, order string) error {
	err := Get.Table(base.TableName).Where(query).Order(order).First(dataStruct).Error
	return err
}

func (base *Base) ListData(dataStruct interface{}, query interface{}, order string, limit int) error {
	err := Get.Table(base.TableName).Where(query).Order(order).Limit(limit).Find(dataStruct).Error
	return err
}

func (base *Base) PageData(dataStruct interface{}, query interface{}, order string, limit int, page int) error {
	err := Get.Table(base.TableName).Where(query).Order(order).Limit(limit).Offset(page * limit).Find(dataStruct).Error
	return err
}

func (base *Base) CountData(query interface{}) (int, error) {
	count := 0
	err := Get.Table(base.TableName).Where(query).Count(&count).Error
	return count, err
}

func (base *Base) DeleteData(dataStruct interface{}, query interface{}) error {
	err := Get.Table(base.TableName).Where(query).Delete(dataStruct).Error
	return err
}
