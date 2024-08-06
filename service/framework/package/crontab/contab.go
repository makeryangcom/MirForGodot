/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package CrontabPackage

import (
	"github.com/robfig/cron/v3"
)

func Start() {
	cronTab := cron.New(cron.WithSeconds())
	_, _ = cronTab.AddFunc("*/10 * * * * *", func() {
		// every 10 seconds
	})
	_, _ = cronTab.AddFunc("0 */1 * * * *", func() {
		// every 10 minute
	})
	cronTab.Start()
}
