#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node

# 自定义数据
var client_peer:ENetMultiplayerPeer

# 数据结构
var data = {
	"client_id": 0
}

# 创建客户端并返回客户端状态数据
func create_client() -> int:
	client_peer = ENetMultiplayerPeer.new()
	var error = client_peer.create_client(Global.get_server_address(), Global.get_server_port())
	if error == OK:
		multiplayer.multiplayer_peer = client_peer
		multiplayer.server_disconnected.connect(_on_server_disconnected)
		update_client_id(multiplayer.get_unique_id())
	return error

# 获取客户端ID数据
func get_client_id() -> int:
	return data["client_id"]

# 更新客户端ID数据
func update_client_id(client_id: int) -> void:
	data["client_id"] = client_id

# 与服务器断开连接时回调函数
func _on_server_disconnected() -> void:
	print("[client:server:disconnected]")
	client_peer.close()

# 关闭客户端
func on_close() -> void:
	print("[client:close]")
	client_peer.close()
