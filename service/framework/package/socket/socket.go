/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package SocketPackage

import (
	"encoding/json"
	"github.com/gorilla/websocket"
	"net/http"
)

var Message = &message{}

type message struct {
	User   map[*websocket.Conn]bool
	Status bool
}

var SocketGrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

type MessageFormat struct {
	Command string `json:"command"`
}

func Callback(message []byte) {
	jsonFormat := MessageFormat{}
	err := json.Unmarshal(message, &jsonFormat)
	if err != nil {
		return
	}
}
