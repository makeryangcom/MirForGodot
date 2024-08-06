/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"github.com/gin-gonic/gin"
	"strings"
)

func CheckHeader(c *gin.Context) (bool, int) {

	status := false
	accountUID := 0

	referer := c.Request.Header.Get("Accept-Fetch-Referer")
	if referer != "" {
		allowedReferer := []string{
			"makeryang.com",
		}
		for _, allowedReferer := range allowedReferer {
			if strings.HasPrefix(referer, allowedReferer) {
				status = true
			}
		}
	}

	auth := c.Request.Header.Get("Accept-Fetch-Auth")
	if auth != "" {
		uidMap, _ := DecodeId(128, auth)
		if len(uidMap) > 0 {
			accountUID = uidMap[0]
		}
	}

	return status, accountUID
}
