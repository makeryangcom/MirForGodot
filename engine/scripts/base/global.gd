#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node

# 数据结构
var data = {
	"version": ProjectSettings.get_setting("application/config/version"),
	"mode": "",
	"environment": "development", # 可选择：production 或 development
	"config": {
		"resource": {
			"speed_scale": 8
		},
		"tilemap":{
			"grid_size": Vector2(48, 32)
		}
	},
	"path": {
		"map": "res://scenes/world/maps/",
		"clothe": "res://scenes/world/player/clothes/",
		"weapon": "res://scenes/world/player/weapons/",
		"wing": "res://scenes/world/player/wings/"
	},
	"server": {
		"port": 7200,
		"address": "api.mir2.geekros.com",
		"socket": {
			"port": 7100,
			"address": "localhost"
		},
		"area": [],
		"role": []
	}
}

func _ready() -> void:
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))
	# 服务器模式检测
	if OS.has_feature("dedicated_server"):
		print("[mode]:server")
		data["mode"] = "server"
		var error = Socket.on_connect_socket()
		if error == OK:
			print("[connect:socket]", "success")
			error = Server.create_server()
			if error == OK:
				print("[server:create]", "success")
			else:
				printerr("[server:create]", "error")
		else:
			printerr("[connect:socket]", "error")
	else:
		print("[mode]:client")
		data["mode"] = "client"

# 获取版本信息
func get_version() -> String:
	return data["version"]

# 是否为服务器模式
func is_server() -> bool:
	var server = false
	if data["mode"] == "server":
		server = true
	return server

# 获取服务器地址
func get_server_address() -> String:
	return data["server"]["address"]

# 获取服务器端口
func get_server_port() -> int:
	return data["server"]["port"]

# 获取服务器socket地址
func get_server_socket_address() -> String:
	return data["server"]["socket"]["address"]

# 获取服务器socket端口
func get_server_socket_port() -> int:
	return data["server"]["socket"]["port"]

# 获取游戏服务区
func get_server_area() -> Array:
	return data["server"]["area"]

# 更新并返回游戏服务区
func update_server_area(area: Array) -> Array:
	data["server"]["area"] = area
	return data["server"]["area"]

# 获取游戏人物角色
func get_server_role() -> Array:
	return data["server"]["role"]

# 更新并返回游戏人物角色
func update_server_role(role: Array) -> Array:
	data["server"]["role"] = role
	return data["server"]["role"]

# 获取地图资源根路径
func get_map_root_path() -> String:
	return data["path"]["map"]

# 获取服饰资源根路径
func get_clothe_root_path() -> String:
	return data["path"]["clothe"]

# 获取武器资源根路径
func get_weapon_root_path() -> String:
	return data["path"]["weapon"]

# 获取翅膀资源根路径
func get_wing_root_path() -> String:
	return data["path"]["wing"]

# 获取资源动画速度帧
func get_resource_speed_scale() -> int:
	return data["config"]["resource"]["speed_scale"]

# 获取TileMap网格尺寸
func get_map_grid_size() -> Vector2:
	return data["config"]["tilemap"]["grid_size"]
