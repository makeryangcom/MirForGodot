/**
#*****************************************************************************
# @file    phone.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Utils

import (
	"regexp"
)

func MobileFormat(str string) string {
	re, _ := regexp.Compile("(\\d{3})(\\d{6})(\\d{2})")
	return re.ReplaceAllString(str, "$1******$3")
}
