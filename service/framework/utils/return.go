/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"math"
	"net/http"
	"os"
	"strconv"
	"time"
)

type logData struct {
	ClientIp           string          `json:"client_ip"`
	ClientMethod       string          `json:"client_method"`
	ClientUrl          string          `json:"client_url"`
	AcceptFetchId      string          `json:"accept_fetch_id"`
	AcceptFetchReferer string          `json:"accept_fetch_referer"`
	AcceptFetchVisitor string          `json:"accept_fetch_visitor"`
	AcceptFetchAuth    string          `json:"accept_fetch_auth"`
	ClientParameter    clientParameter `json:"client_parameter"`
	ServerParameter    string          `json:"server_parameter"`
	Date               string          `json:"date"`
	Time               int64           `json:"time"`
	Server             string          `json:"server"`
	Length             string          `json:"length"`
}

type clientParameter struct {
	Get  interface{} `json:"get"`
	Post interface{} `json:"post"`
}

func requestLog(c *gin.Context, serverParameter string) {

	data := &logData{}
	data.Time = time.Now().Unix()
	data.Date = time.Now().Format("2006-01-02 15:04:05")
	data.ClientMethod = c.Request.Method
	data.ClientIp = c.ClientIP()
	data.AcceptFetchId = c.Request.Header.Get("Accept-Fetch-Id")
	data.AcceptFetchReferer = c.Request.Header.Get("Accept-Fetch-Referer")
	data.AcceptFetchVisitor = c.Request.Header.Get("Accept-Fetch-Visitor")
	data.AcceptFetchAuth = c.Request.Header.Get("Accept-Fetch-Auth")
	if data.ClientMethod == "GET" {
		data.ClientParameter.Get = c.Request.URL.Query()
	}
	if data.ClientMethod == "POST" {
		data.ClientParameter.Post = c.Request.PostForm
	}
	scheme := "http://"
	if c.Request.TLS != nil {
		scheme = "https://"
	}
	serverUrl := scheme + c.Request.Host + c.Request.URL.Path
	data.ClientUrl = serverUrl
	serverName, _ := os.Hostname()
	data.Server = serverName
	data.ServerParameter = serverParameter

	clientTimeStr := c.Request.Header.Get("Client-Time")
	if clientTimeStr != "" {
		clientTimeMs, _ := strconv.ParseInt(clientTimeStr, 10, 64)
		serverTimeMs := time.Now().UnixNano() / 1e6
		processingTimeMs := serverTimeMs - clientTimeMs
		data.Length = fmt.Sprintf("%.3f", math.Abs(float64(processingTimeMs)/1000.0))
	}

	dataString, _ := json.Marshal(data)

	log.Println("[request]", string(dataString))
}

func Success(c *gin.Context, data interface{}) {

	c.JSON(http.StatusOK, gin.H{
		"code":    0,
		"msg":     "success",
		"message": "success",
		"data":    data,
	})

	logJson, _ := json.Marshal(gin.H{"code": 0, "msg": "success", "message": "success", "data": data})

	requestLog(c, string(logJson))
}

func Error(c *gin.Context, data interface{}) {

	c.JSON(http.StatusOK, gin.H{
		"code":    10000,
		"msg":     "error",
		"message": "error",
		"data":    data,
	})

	logJson, _ := json.Marshal(gin.H{"code": 10000, "msg": "error", "message": "error", "data": data})

	requestLog(c, string(logJson))
}

func Warning(c *gin.Context, code int, msg string, data interface{}) {

	c.JSON(http.StatusOK, gin.H{
		"code":    code,
		"msg":     msg,
		"message": msg,
		"data":    data,
	})

	logJson, _ := json.Marshal(gin.H{"code": code, "msg": msg, "message": msg, "data": data})

	requestLog(c, string(logJson))
}

func AuthError(c *gin.Context, code int, msg string, data interface{}) {

	c.JSON(http.StatusUnauthorized, gin.H{
		"code":    code,
		"msg":     msg,
		"message": msg,
		"data":    data,
	})

	logJson, _ := json.Marshal(gin.H{"code": code, "msg": msg, "message": msg, "data": data})

	requestLog(c, string(logJson))
}
