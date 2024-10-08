#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var drag_button: TextureButton = $Background/DragButton
@onready var close_button: TextureButton = $Background/CloseButton
@onready var footer: Control = $Footer
@onready var footer_integral: Label = $Footer/FooterIntegral
@onready var footer_balance: Label = $Footer/FooterBalance

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
		footer_integral.text = Account.get_player_integral(parent_node.player_data)
		footer_balance.text = Account.get_player_balance(parent_node.player_data)
		if is_drag:
			position = get_global_mouse_position() + offset

# 背景按钮按下击事件函数
func _on_drag_button_button_down() -> void:
	if parent_node:
		if !is_drag:
			on_click_signal.emit("PackageMain", false)
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
