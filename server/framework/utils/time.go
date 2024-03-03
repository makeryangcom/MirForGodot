package Utils

import (
	"strconv"
	"time"
)

func TimeFormat(unix int) (string, string) {
	timeInt := time.Unix(int64(unix), 0)
	return timeInt.Format("2006年01月02日"), timeInt.Format("2006-01-02 15:04:05")
}

func DateFormat(times int) string {
	createTime := time.Unix(int64(times), 0)
	now := time.Now().Unix()

	difTime := now - int64(times)

	str := ""
	if difTime < 60 {
		str = "刚刚"
	} else if difTime < 3600 {
		M := difTime / 60
		str = strconv.Itoa(int(M)) + "分钟前"
	} else if difTime < 3600*24 {
		H := difTime / 3600
		str = strconv.Itoa(int(H)) + "小时前"
	} else {
		str = createTime.Format("2006-01-02 15:04:05")
	}

	return str
}
