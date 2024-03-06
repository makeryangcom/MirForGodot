/**
#*****************************************************************************
# @file    rand.go
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
*/

package Utils

import (
	"fmt"
	"math/rand"
	"time"
)

func RandInt(min, max int) int {
	if min >= max || min == 0 || max == 0 {
		return max
	}
	return rand.Intn(max-min) + min
}

func RandCode() string {
	randNumber := rand.New(rand.NewSource(time.Now().UnixNano()))
	code := fmt.Sprintf("%06v", randNumber.Int31n(1000000))
	return code
}
