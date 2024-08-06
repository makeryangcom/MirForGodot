#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node

# 数据结构
var data = {
	"players": {}
}

# 自定义数据
var server_peer:ENetMultiplayerPeer

# 预加载资源
@onready var player_scenes: PackedScene = preload("res://scenes/world/player/player.tscn")

# 创建服务器并返回服务器状态
func create_server() -> int:
	server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(Global.get_server_port())
	if error == OK:
		multiplayer.multiplayer_peer = server_peer
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	return error

# 客户端连接服务器时回调函数
func _on_peer_connected(client_id: int) -> void:
	if multiplayer.is_server():
		print("[server:client:connected]", "当前:" + str(multiplayer.get_unique_id()), "-->", "目标:" + str(client_id))
		# 通知当前连接客户端同步所有玩家数据
		rpc_id(client_id, "sync_players_data", client_id, JSON.stringify(data["players"]))

# 客户端断开服务器时回调函数
func _on_peer_disconnected(client_id: int) -> void:
	if data["players"][str(client_id)] and multiplayer.is_server():
		print("[server:client:disconnected]", "当前:" + str(multiplayer.get_unique_id()), "-->", "目标:" + str(client_id))
		var internal_url = "/internal/player/update/client/id?token=" + data["players"][str(client_id)]["token"] + "&client_id=" + str(0)
		Request.on_internal(internal_url, HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					printerr("[server:client:disconnected:update:client:id]", JSON.stringify(response))
					return
				print("[server:client:disconnected:update:client:id]", JSON.stringify(response))
				var players_node = get_parent().get_node("World").get_node("Main").get_node(data["players"][str(client_id)]["player_map"]).get_node("Players")
				if players_node.has_node(str(client_id)):
					var player_node = players_node.get_node(str(client_id))
					player_node.queue_free()
					data["players"].erase(str(client_id))
					print("[server:client:disconnected:remove]", str(client_id))
					rpc("on_remove_player", client_id)
			else:
				printerr("[server:request:ping]", "error")
		)

@rpc("any_peer", "call_remote")
func on_add_player(client_id: int, player_data: String) -> void:
	if multiplayer.is_server():
		print("[server:add:player] ", "当前:" + str(multiplayer.get_unique_id()), "-->", "目标:" + str(client_id))
		var player_json = JSON.parse_string(player_data)
		data["players"][str(client_id)] = player_json
		rpc("sync_player_data", client_id, player_data)
		var players_node: Node2D = get_parent().get_node("World").get_node("Main").get_node(player_json["player_map"]).get_node("Players")
		var player_node:Player = player_scenes.instantiate()
		player_node.name = str(client_id)
		players_node.add_child(player_node)

@rpc("any_peer", "call_remote")
func on_remove_player(client_id: int) -> void:
	if !multiplayer.is_server():
		print("[client:disconnected:remove]", "当前:" + str(multiplayer.get_unique_id()), "-->", "目标:" + str(client_id))
		data["players"].erase(str(client_id))

@rpc("any_peer", "call_remote")
# 客户端同步玩家数据
func sync_player_data(client_id: int, player_data: String) -> void:
	if !multiplayer.is_server():
		print("[client:sync:player] ", "当前:" + str(multiplayer.get_unique_id()), "-->", "目标:" + str(client_id))
		var player_json = JSON.parse_string(player_data)
		data["players"][str(client_id)] = player_json

@rpc("any_peer", "call_remote")
# 客户端同步所有玩家数据
func sync_players_data(client_id: int, players_data: String) -> void:
	if !multiplayer.is_server():
		print("[client:sync:players] ", "当前:" + str(multiplayer.get_unique_id()), "-->", "目标:" + str(client_id))
		var player_json = JSON.parse_string(players_data)
		data["players"] = player_json
