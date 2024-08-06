#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var drag_button: TextureButton = $Background/DragButton
@onready var close_button: TextureButton = $Background/CloseButton
@onready var nickname: Label = $Nickname
@onready var tab_box: Control = $TabBox
@onready var equip_tab_button: TextureButton = $TabBox/EquipTabButton
@onready var state_tab_button: TextureButton = $TabBox/StateTabButton
@onready var attribute_tab_button: TextureButton = $TabBox/AttributeTabButton
@onready var title_tab_button: TextureButton = $TabBox/TitleTabButton
@onready var skill_tab_button: TextureButton = $TabBox/SkillTabButton
@onready var equip_box: Control = $EquipBox
@onready var men_background: TextureRect = $EquipBox/MenBackground
@onready var women_background: TextureRect = $EquipBox/WomenBackground
@onready var state_box: Control = $StateBox
@onready var attribute_box: Control = $AttributeBox
@onready var title_box: Control = $TitleBox
@onready var skill_box: Control = $SkillBox

# 场景信号
signal on_click_signal(type: String, source: bool)

# 场景数据
var parent_node: CanvasLayer
var current_tab: String = "equip"
var is_drag: bool = false
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	parent_node = get_parent().get_parent()
	visible = false
	equip_box.visible = false
	state_box.visible = false
	attribute_box.visible = false
	title_box.visible = false
	skill_box.visible = false

func _process(_delta: float) -> void:
	if parent_node and parent_node.player_data:
		nickname.text = Account.get_player_nickname(parent_node.player_data)
		on_batch_process();
		if current_tab == "equip":
			equip_tab_button.button_pressed = true
			if Account.get_player_gender(parent_node.player_data) == "men":
				men_background.visible = true
				women_background.visible = false
			else:
				men_background.visible = false
				women_background.visible = true
			equip_box.visible = true
		if current_tab == "state":
			state_tab_button.button_pressed = true
			state_box.visible = true
		if current_tab == "attribute":
			attribute_tab_button.button_pressed = true
			attribute_box.visible = true
		if current_tab == "title":
			title_tab_button.button_pressed = true
			title_box.visible = true
		if current_tab == "skill":
			skill_tab_button.button_pressed = true
			skill_box.visible = true
		if is_drag:
			position = get_global_mouse_position() + offset

# 面板显示批处理
func on_batch_process() -> void:
	equip_tab_button.button_pressed = false
	state_tab_button.button_pressed= false
	attribute_tab_button.button_pressed= false
	title_tab_button.button_pressed= false
	skill_tab_button.button_pressed= false
	equip_box.visible = false
	state_box.visible = false
	attribute_box.visible = false
	title_box.visible = false
	skill_box.visible = false

# 面板TAB切换事件函数
func _on_tab_button_pressed(type: String) -> void:
	if parent_node:
		if current_tab != type:
			current_tab = type

# 显示事件函数
func on_show() -> void:
	if parent_node:
		visible = true

# 背景按钮按下击事件函数
func _on_drag_button_button_down() -> void:
	if parent_node:
		if !is_drag:
			on_click_signal.emit("PanelMain", false)
		offset = position - get_global_mouse_position()
		is_drag = true

# 背景按钮击事件函数
func _on_drag_button_button_up() -> void:
	if parent_node:
		is_drag = false

# 关闭按钮事件函数
func _on_close_button_pressed() -> void:
	if parent_node:
		parent_node.on_button_pressed_music()
		visible = false
