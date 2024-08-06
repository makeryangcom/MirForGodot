/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"fmt"
	"strconv"
	"time"
)

func TimeFormat(unix int) (string, string) {

	timeInt := time.Unix(int64(unix), 0)

	return timeInt.Format("2006年01月02日 15:04:05"), timeInt.Format("2006-01-02 15:04:05")
}

func TimeMinFormat(unix int) (string, string) {

	timeInt := time.Unix(int64(unix), 0)

	return timeInt.Format("2006年01月02日"), timeInt.Format("2006-01-02")
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

func DateFormatFine(timestamp int64) string {
	now := time.Now()
	past := time.Unix(timestamp, 0) // Convert Unix timestamp to time.Time
	duration := now.Sub(past)

	// Calculate the differences
	seconds := int(duration.Seconds())
	minutes := int(duration.Minutes())
	hours := int(duration.Hours())
	days := hours / 24
	weeks := days / 7
	// months := days / 30

	switch {
	case seconds < 60:
		return fmt.Sprintf("%d 秒前", seconds)
	case minutes < 60:
		return fmt.Sprintf("%d 分钟前", minutes)
	case hours < 24:
		return fmt.Sprintf("%d 小时前", hours)
	case days < 7:
		return fmt.Sprintf("%d 天前", days)
	case days < 30:
		return fmt.Sprintf("%d 周前", weeks)
	default:
		return past.Format("2006年01月02日")
	}
}
