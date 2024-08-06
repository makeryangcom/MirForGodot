#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node

# 数据结构
var data = {
	"request": HTTPRequest.new(),
	"callback": null,
	"headers": [
		"Content-Type: application/json",
		"Accept-Fetch-Id: godot",
		"Accept-Fetch-Referer: makeryang.com",
		"Accept-Fetch-Visitor:",
		"Accept-Fetch-Auth:"
	]
}

# 请求服务器接口
func on_server(path: String, method: int, parameter, callback) -> void:
	if !data["request"].is_inside_tree():
		add_child(data["request"])
	var parameter_json = JSON.stringify(parameter)
	data["headers"][3] = "Accept-Fetch-Auth: " + Account.get_token()
	if data["callback"] and data["request"].is_connected("request_completed", data["callback"]):
		data["request"].request_completed.disconnect(data["callback"])
	data["request"].request_completed.connect(callback)
	data["callback"] = callback
	data["request"].request("https://" + Global.get_server_address() + path, data["headers"], method, parameter_json)

# 请求服务器接口
func on_internal(path: String, method: int, parameter, callback) -> void:
	if !data["request"].is_inside_tree():
		add_child(data["request"])
	var parameter_json = JSON.stringify(parameter)
	data["headers"][3] = "Accept-Fetch-Auth: " + Account.get_token()
	if data["callback"] and data["request"].is_connected("request_completed", data["callback"]):
		data["request"].request_completed.disconnect(data["callback"])
	data["request"].request_completed.connect(callback)
	data["callback"] = callback
	data["request"].request("http://" + Global.get_server_socket_address() + ":" + str(Global.get_server_socket_port()) + path, data["headers"], method, parameter_json)
