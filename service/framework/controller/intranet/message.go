/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package IntranetController

import (
	"Service/framework/package/socket"
	"encoding/json"
	"github.com/gin-gonic/gin"
	"github.com/gookit/color"
	"github.com/gorilla/websocket"
	"log"
)

func MessageIndex(c *gin.Context) {

	conn, err := SocketPackage.SocketGrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Println("[controller:intranet:message:index:error]", color.Yellow.Text("websocket upgrade error:"+err.Error()))
		return
	}

	if SocketPackage.Message.Status == false {
		SocketPackage.Message.User = make(map[*websocket.Conn]bool)
		SocketPackage.Message.Status = true
	}

	SocketPackage.Message.User[conn] = true

	log.Println("[controller:intranet:message:index]", color.Green.Text("game server connection socket..."))

	for {
		_, data, err := conn.ReadMessage()
		if err != nil {
			_ = conn.Close()
			delete(SocketPackage.Message.User, conn)
			return
		}

		SocketPackage.Callback(data)

		jsonFormat := SocketPackage.MessageFormat{}
		err = json.Unmarshal(data, &jsonFormat)
		if err == nil {
			if jsonFormat.Command != "" {
				for user := range SocketPackage.Message.User {
					err := user.WriteMessage(websocket.TextMessage, data)
					if err != nil {
						_ = user.Close()
						delete(SocketPackage.Message.User, user)
					}
				}

			}
		}
	}
}
