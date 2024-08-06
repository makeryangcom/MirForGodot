/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import "fmt"

func PriceConvert(num int) string {
	return fmt.Sprintf("%.2f", float64(num)/100)
}
