/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Framework

import (
	"Service/framework/config"
	"Service/framework/database"
	"Service/framework/package/crontab"
)

func Init() {
	Config.Setup()
	Database.Init()
	CrontabPackage.Start()
}
