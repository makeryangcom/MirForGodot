#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node

# 自定义数据
var socket_peer:WebSocketPeer

# 数据结构
var data = {
	"status": false
}

func on_connect_socket() -> int:
	socket_peer = WebSocketPeer.new()
	var error = socket_peer.connect_to_url("ws://%s:%d/internal/message/index" % [Global.get_server_socket_address(), Global.get_server_socket_port()])
	if error != OK:
		data["status"] = false
	else:
		data["status"] = true
	return error

func _process(_delta) -> void:
	if data["status"]:
		socket_peer.poll()
