#*****************************************************************************
# @file    request.gd
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
extends Node

# 初始化自定义数据
var http_request:HTTPRequest = HTTPRequest.new()
var http_callback = null

# 初始化数据结构
var data = {
	"headers": [
		"Content-Type: application/json",
		"Account-Token: ",
	]
}

# 请求服务器接口
func on_server(path: String, method: int, parameter, callback) -> void:
	if !http_request.is_inside_tree():
		add_child(http_request)
	var parameter_json = JSON.stringify(parameter)
	data["headers"][1] = "Account-Token: " + Global.get_account_token()
	if http_callback and http_request.is_connected("request_completed", http_callback):
		http_request.request_completed.disconnect(http_callback)
	http_request.request_completed.connect(callback)
	http_callback = callback
	http_request.request("https://" + Global.get_server_address() + path, data["headers"], method, parameter_json)

# 测试服务器接口
func on_server_ping() -> void:
	on_server("/ping", HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
		if code == 200:
			var response = JSON.parse_string(body.get_string_from_utf8())
			if response["code"] == 0:
				print("[服务器接口:/ping]", JSON.stringify(response))
			else:
				printerr("[服务器接口:/ping]", "服务器接口通讯失败")
		else:
			printerr("[服务器接口:/ping]", "服务器接口通讯失败")
	)
