#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

class_name World extends Node2D

# 场景资源
@onready var main: Node2D = $Main
@onready var interface: CanvasLayer = $Interface
@onready var loading: Control = $Interface/Loading

# 场景数据
var is_loader: bool = false
var loader_progress: Array = []

func _ready() -> void:
	print("[world:ready]")
	if Global.is_server():
		#var child_node = get_node("Interface")
		#if child_node:
			#remove_child(child_node)
			#child_node.queue_free()
		on_server_loader_map()
		return
	main.visible = false
	interface.visible = true
	loading.visible = true

func _process(_delta: float) -> void:
	if !Global.is_server():
		if !is_loader:
			on_player_map_loader()

# 服务器加载地图资源函数
func on_server_loader_map() -> void:
	print("[world:server:loader:map]")
	Request.on_internal("/internal/map/list", HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
		if code == 200:
			var response = JSON.parse_string(body.get_string_from_utf8())
			if response.code == 0:
				if len(response.data.map) > 0:
					for i in range(len(response.data.map)):
						var map_scene:Node2D = load(Global.get_map_root_path() + response.data.map[i].map_number + "/" + response.data.map[i].map_number + ".tscn").instantiate()
						main.add_child(map_scene)
						print("[world:server:loader:map] ", response.data.map[i].map_name + " ", response.data.map[i].map_number + " ", "" + str(i+1) + "/" + str(len(response.data.map)))
				on_server_loader_npc()
		else:
			print("[world:server:loader:map:error]")
	)

# 服务器加载NPC资源函数
func on_server_loader_npc() -> void:
	print("[world:server:loader:npc]")
	on_server_loader_monster()

# 服务器加载怪物资源函数
func on_server_loader_monster() -> void:
	print("[world:server:loader:monster]")

# 加载玩家地图资源函数
func on_player_map_loader() -> void:
	var map_scene_path = Account.get_player_map_path(Account.get_player())
	ResourceLoader.load_threaded_request(map_scene_path)
	var loader_status = ResourceLoader.load_threaded_get_status(map_scene_path, loader_progress)
	loading.progress_bar.value = (loader_progress[0] * 100)
	if loader_status == ResourceLoader.THREAD_LOAD_LOADED:
		print("[world:player:map:loader]")
		is_loader = true
		main.add_child(load(map_scene_path).instantiate())
		await get_tree().create_timer(0.2).timeout
		var error = Client.create_client()
		if error == OK:
			print("[client:create]", "success")
			await multiplayer.multiplayer_peer.peer_connected
			var server_url = "/game/player/update/client/id?token=" + Account.get_player_token() + "&client_id=" + str(Client.get_client_id())
			Request.on_server(server_url, HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
				if code == 200:
					var response = JSON.parse_string(body.get_string_from_utf8())
					if response.code != 0:
						printerr("[client:create:update:client:id]", JSON.stringify(response))
						return
					Server.on_add_player.rpc(Client.get_client_id(), JSON.stringify(Account.get_player()))
					await get_tree().create_timer(0.2).timeout
					main.visible = true
					loading.visible = false
				else:
					printerr("[request:ping]", "error")
			)
		else:
			printerr("[client:create]", "error")
