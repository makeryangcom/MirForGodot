package Utils

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

type logData struct {
	Timestamp       int64  `json:"timestamp"`
	TimestampFormat string `json:"timestamp_format"`
	ClientMethod    string `json:"client_method"`
	ClientIp        string `json:"client_ip"`
	ClientParameter string `json:"client_parameter"`
	ServerParameter string `json:"server_parameter"`
	ServerUrl       string `json:"server_url"`
	ServerName      string `json:"server_name"`
	ServerYear      string `json:"server_year"`
	ServerMonth     string `json:"server_month"`
	ServerDay       string `json:"server_day"`
	ServerTime      string `json:"server_time"`
	TimeLength      string `json:"time_length"`
}

func recordLog(c *gin.Context, serverParameter string) {
	data := &logData{}
	data.Timestamp = time.Now().Unix()
	data.TimestampFormat = time.Now().Format("2006-01-02 15:04:05")
	data.ClientMethod = c.Request.Method
	data.ClientIp = c.ClientIP()
	if data.ClientMethod == "GET" {
		data.ClientParameter = c.Request.RequestURI
	}
	if data.ClientMethod == "POST" {
		clientParam, err := json.Marshal(c.Request.PostForm)
		if err != nil {
			data.ClientParameter = ""
		}
		if err == nil {
			data.ClientParameter = string(clientParam)
		}
	}
	scheme := "http://"
	if c.Request.TLS != nil {
		scheme = "https://"
	}
	serverUrl := scheme + c.Request.Host + c.Request.URL.Path
	serverName, _ := os.Hostname()
	data.ServerUrl = serverUrl
	data.ServerName = serverName
	data.ClientParameter = c.GetString("client_parameter")
	data.ServerParameter = serverParameter
	data.ServerYear = time.Now().Format("2006")
	data.ServerMonth = time.Now().Format("01")
	data.ServerDay = time.Now().Format("02")
	data.ServerTime = time.Now().Format("15:04:05")
	data.TimeLength = strconv.FormatFloat(float64(time.Now().UnixNano())/1000000-c.GetFloat64("start_time"), 'f', 2, 64)
	dataString, _ := json.Marshal(data)

	log.Println("[Log]", string(dataString))
}

func Success(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, gin.H{
		"code": 0,
		"msg":  "success",
		"data": data,
	})
	logJson, _ := json.Marshal(gin.H{"code": 0, "msg": "success", "data": data})
	recordLog(c, string(logJson))
}

func Error(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, gin.H{
		"code": 10000,
		"msg":  "error",
		"data": data,
	})
	logJson, _ := json.Marshal(gin.H{"code": 10000, "msg": "error", "data": data})
	recordLog(c, string(logJson))
}

func Warning(c *gin.Context, code int, msg string, data interface{}) {
	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg":  msg,
		"data": data,
	})
	logJson, _ := json.Marshal(gin.H{"code": code, "msg": msg, "data": data})
	recordLog(c, string(logJson))
}

func AuthError(c *gin.Context, code int, msg string, data interface{}) {
	c.JSON(http.StatusUnauthorized, gin.H{
		"code": code,
		"msg":  msg,
		"data": data,
	})
	logJson, _ := json.Marshal(gin.H{"code": code, "msg": msg, "data": data})
	recordLog(c, string(logJson))
}
