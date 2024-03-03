#*****************************************************************************
# @file    server.gd
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
extends Node

# 初始化自定义数据
var server_peer:ENetMultiplayerPeer

# 创建服务器并返回服务器状态
func create_server() -> int:
	print("[创建服务器...]")
	server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(Global.get_server_port())
	if error == OK:
		multiplayer.multiplayer_peer = server_peer
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		print("[服务器创建成功]")
	return error

# 客户端连接服务器时回调函数
func _on_peer_connected(id: int) -> void:
	print("[新的客户端连接 " + str(id) + "]")

# 客户端断开服务器时回调函数
func _on_peer_disconnected(id: int) -> void:
	print("[客户端连接断开 " + str(id) + "]")
