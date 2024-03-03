#*****************************************************************************
# @file    client.gd
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
extends Node

# 初始化自定义数据
var client_peer:ENetMultiplayerPeer

# 初始化数据结构
var data = {
	"client_id": 0
}

# 创建客户端并返回客户端状态
func create_client() -> int:
	client_peer = ENetMultiplayerPeer.new()
	var error = client_peer.create_client(Global.get_server_address(), Global.get_server_port())
	if error == OK:
		multiplayer.multiplayer_peer = client_peer
		# 更新客户端ID
		update_client_id(multiplayer.get_unique_id())
	return error

# 更新客户端ID
func update_client_id(client_id: int) -> void:
	data["client_id"] = client_id
