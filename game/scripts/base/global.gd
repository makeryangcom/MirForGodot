#*****************************************************************************
# @file    global.gd
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
extends Node

# 初始化数据结构
var data = {
	"varsion": "1.0.0",
	"mode": "",
	"server": {
		"port": 9000,
		"address": "game.makeryang.com"
	},
	"account": {
		"token": ""
	}
}

func _ready() -> void:
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))
	# 服务器模式检测
	if OS.has_feature("dedicated_server"):
		print("[服务器模式]")
		data["mode"] = "server"
		var error = Server.create_server()
		if error != OK:
			printerr("[服务器创建失败]")
	else:
		print("[客户端模式]")
		data["mode"] = "client"
		Request.on_server_ping()
		var error = Client.create_client()
		if error == OK:
			print("[服务器连接成功]")
		else:
			printerr("[服务器连接失败]")

# 是否为服务器模式
func is_server() -> bool:
	var server = false
	if data["mode"] == "server":
		server = true
	return server

# 获取服务器端口
func get_server_port() -> int:
	return data["server"]["port"]

# 获取服务器IP
func get_server_ip() -> String:
	return data["server"]["ip"]

# 获取服务器地址
func get_server_address() -> String:
	return data["server"]["address"]

# 获取用户Token
func get_account_token() -> String:
	return data["account"]["token"]
