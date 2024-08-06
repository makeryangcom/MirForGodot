#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var min_main: Control = $"."
@onready var min_map_label: Label = $MinMapHeader/MinMapLabel
@onready var min_map_show_button: TextureButton = $MinMapShowButton
@onready var min_map_hide_button: TextureButton = $MinMapHideButton
@onready var min_map_mask: TextureRect = $MinMapMask
@onready var min_map_main_viewport: SubViewport = $MinMapMask/MinMapMain/MinMapMainViewport
@onready var min_map_main_viewport_location: TextureRect = $MinMapMask/MinMapMain/MinMapMainViewport/MinMapMainViewportLocation
@onready var min_map_main_viewport_camera: Camera2D = $MinMapMask/MinMapMain/MinMapMainViewport/MinMapMainViewportCamera
@onready var min_map_main_button: TextureButton = $MinMapMask/MinMapMainButton

# 场景信号
signal on_click_signal(type: String, source: bool)

# 场景数据
var parent_node: CanvasLayer
var min_map_mask_show: bool = true

func _ready() -> void:
	parent_node = get_parent().get_parent()
	min_map_show_button.visible = false
	min_map_hide_button.visible = true

func _process(_delta: float) -> void:
	if parent_node and parent_node.player_data:
		min_map_label.text = Account.get_player_map_name(parent_node.player_data)
		min_map_main_viewport_location.scale = Vector2(8, 8)
		if min_map_mask_show:
			min_map_show_button.visible = false
			min_map_hide_button.visible = true
		else:
			min_map_show_button.visible = true
			min_map_hide_button.visible = false

# 小地图隐藏按钮事件函数
func _on_min_map_hide_button_pressed() -> void:
	if min_map_mask_show:
		print("[interface:min:map:hide:button]")
		parent_node.on_button_pressed_music()
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(min_map_mask, "position:y", (min_map_mask.position.y - 145), 0.2)
		min_map_mask_show = false

# 小地图显示按钮事件函数
func _on_min_map_show_button_pressed() -> void:
	if !min_map_mask_show:
		print("[interface:min:map:show:button]")
		parent_node.on_button_pressed_music()
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(min_map_mask, "position:y", (min_map_mask.position.y + 145), 0.2)
		min_map_mask_show = true

# 小地图缩放事件函数
func on_scale_map() -> void:
	var current_zoom = min_map_main_viewport_camera.zoom
	if current_zoom.x > 0.06 and current_zoom.y > 0.06:
		min_map_main_viewport_camera.zoom = Vector2(0.05, 0.05)
	if current_zoom.x < 0.06 and current_zoom.y < 0.06:
		min_map_main_viewport_camera.zoom = Vector2(0.1, 0.1)

# 小地图按钮事件函数
func _on_min_map_main_button_pressed() -> void:
	print("[interface:min:map:main:button]")
	parent_node.on_button_pressed_music()
	on_click_signal.emit("MaxMain", false)
