#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var max_main: Control = $"."
@onready var drag_button: TextureButton = $MaxMapMask/DragButton
@onready var close_button: TextureButton = $MaxMapMask/CloseButton
@onready var main: Control = $Main
@onready var main_container: SubViewportContainer = $Main/MainContainer
@onready var main_viewport: SubViewport = $Main/MainContainer/MainViewport
@onready var main_viewport_location: TextureRect = $Main/MainContainer/MainViewport/MainViewportLocation
@onready var main_viewport_camera: Camera2D = $Main/MainContainer/MainViewport/MainViewportCamera

# 场景信号
signal on_click_signal(type: String, source: bool)

# 场景数据
var parent_node: CanvasLayer
var is_drag: bool = false
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	parent_node = get_parent().get_parent()
	visible = false

func _process(_delta: float) -> void:
	if parent_node and parent_node.player_data:
		main_viewport_location.scale = Vector2(30, 30)
		if is_drag:
			position = get_global_mouse_position() + offset

# 背景按钮按下击事件函数
func _on_drag_button_button_down() -> void:
	if parent_node:
		if !is_drag:
			on_click_signal.emit("MaxMain", false)
		offset = position - get_global_mouse_position()
		is_drag = true

# 背景按钮抬起击事件函数
func _on_drag_button_button_up() -> void:
	if parent_node:
		is_drag = false

# 关闭按钮事件函数
func _on_close_button_pressed() -> void:
	if parent_node:
		parent_node.on_button_pressed_music()
		visible = false
