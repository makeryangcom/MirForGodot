/**
#*****************************************************************************
# @file    price.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Utils

import "fmt"

func PriceConvert(num int) string {
	return fmt.Sprintf("%.2f", float64(num)/100)
}
