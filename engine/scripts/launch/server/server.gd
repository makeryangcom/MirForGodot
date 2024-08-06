#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var button_pressed_music: AudioStreamPlayer2D = $ButtonPressedMusic
@onready var default: Control = $Default
@onready var list: VBoxContainer = $Default/Box/List

# 场景数据
var server_list: Array = []

# 场景信号
signal switch_role_signal(token: String)

func _ready() -> void:
	default.visible = false

func on_server() -> void:
	print("[launch:server:on_server]")
	# 清空当前渲染列表数据
	while list.get_child_count() > 0:
		var last_child = list.get_child(list.get_child_count() - 1)
		list.remove_child(last_child)
		last_child.queue_free()
	Request.on_server("/game/server/index", HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
		if code == 200:
			var response = JSON.parse_string(body.get_string_from_utf8())
			if response.code != 0:
				get_parent().on_dialog(response.message)
				return
			server_list = Global.update_server_area(response.data.server)
			# 渲染列表数据
			var font_path = load("res://assets/common/font/HarmonyOS_Sans_Bold.ttf")
			var texture_normal = load("res://assets/launch/nodes/server/server_button_0.png")
			var texture_pressed = load("res://assets/launch/nodes/server/server_button_1.png")
			var texture_hover = load("res://assets/launch/nodes/server/server_button_2.png")
			for i in range(len(server_list)):
				var item:TextureButton = TextureButton.new()
				var item_label:Label = Label.new()
				item.texture_normal = texture_normal
				item.texture_pressed = texture_pressed
				item.texture_hover = texture_hover
				item.texture_disabled = texture_normal
				item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				item_label.size = Vector2(157, 24)
				item_label.position = Vector2(10, 11)
				item_label.text = server_list[i]["server_name"]
				item_label.add_theme_font_size_override("font_size", 12)
				item_label.add_theme_color_override("font_color", Color("#cba368"))
				item_label.add_theme_font_override("font", font_path)
				item.add_child(item_label)
				item.connect("pressed", _on_item_pressed.bind(server_list[i]["token"]))
				list.add_child(item)
			default.visible = true
		else:
			get_parent().on_dialog("服务区获取失败")
	)

# 服务区按钮事件函数
func _on_item_pressed(_token: String) -> void:
	print("[launch:server:item:pressed]")
	_on_button_pressed_music()
	for i in range(list.get_child_count()):
		list.get_child(i).disabled = true
	default.visible = false
	switch_role_signal.emit(_token)

# 公用按钮音效函数
func _on_button_pressed_music() -> void:
	button_pressed_music.play()
