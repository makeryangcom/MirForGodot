#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var chat_main: Control = $"."
@onready var chat_input_box: Control = $ChatInputBox
@onready var chat_input: LineEdit = $ChatInputBox/ChatInput
@onready var chat_show_button: TextureButton = $ChatShowButton
@onready var chat_hide_button: TextureButton = $ChatHideButton

# 场景数据
var parent_node: CanvasLayer
var chat_main_show: bool = true

func _ready() -> void:
	parent_node = get_parent().get_parent()
	chat_input_box.visible = false
	chat_show_button.visible = false
	chat_hide_button.visible = true

func _process(_delta: float) -> void:
	if parent_node and parent_node.player_data:
		if chat_main_show:
			chat_show_button.visible = false
			chat_hide_button.visible = true
		else:
			chat_show_button.visible = true
			chat_hide_button.visible = false

# 显示聊天信息输入框
func on_show() -> void:
	chat_input_box.visible = true
	await get_tree().create_timer(0.5).timeout
	chat_input.editable = true
	chat_input.grab_focus()

# 发送聊天消息
func on_send_message() -> void:
	if chat_input.text != "":
		pass
	chat_input_box.visible = false
	chat_input.clear()
	chat_input.editable = false

# 聊天框隐藏按钮事件函数
func _on_chat_hide_button_pressed() -> void:
	if chat_main_show:
		print("[interface:chat:hide:button]")
		parent_node.on_button_pressed_music()
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(chat_main, "position:x", (chat_main.position.x - 325), 0.2)
		chat_main_show = false

# 聊天框显示按钮事件函数
func _on_chat_show_button_pressed() -> void:
	if !chat_main_show:
		print("[interface:show:hide:button]")
		parent_node.on_button_pressed_music()
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(chat_main, "position:x", (chat_main.position.x + 325), 0.2)
		chat_main_show = true
