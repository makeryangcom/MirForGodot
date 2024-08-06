#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 数据结构
var data = {
	"key": "",
	"mouse": "",
	"skill": false
}

func _input(event) -> void:
	# 获取窗口的边界
	var viewport_rect = get_viewport_rect()
	# 获取鼠标的位置
	var viewport_mouse_position = get_viewport().get_mouse_position()
	# 如果鼠标在窗口区域内
	if viewport_rect.has_point(viewport_mouse_position):
		if event is InputEventKey:
			if event.pressed:
				if event.as_text_keycode() in ["F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8"]:
					data["skill"] = true
				data["key"] = event.as_text_keycode()
			else:
				data["key"] = ""
				data["skill"] = false
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.pressed:
				data["mouse"] = "left"
			elif event.button_index == 2 and event.pressed:
				data["mouse"] = "right"
			else:
				data["mouse"] = ""

# 获取KEY值
func get_key() -> String:
	return data["key"]

# 获取鼠标按键值
func get_mouse() -> String:
	return data["mouse"]

# 是否为技能KEY值
func is_skill() -> bool:
	return data["skill"]
