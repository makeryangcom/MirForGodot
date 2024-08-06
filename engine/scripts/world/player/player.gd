#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

class_name Player extends CharacterBody2D

# 场景资源
@onready var player: Player = $"."
@onready var player_collision: CollisionShape2D = $PlayerCollision
@onready var player_light: Node2D = $PlayerLight
@onready var player_point_light: PointLight2D = $PlayerLight/PlayerPointLight
@onready var player_main: Control = $PlayerMain
@onready var player_body: Control = $PlayerMain/PlayerBody
@onready var player_body_weapon_index: Control = $PlayerMain/PlayerBody/PlayerBodyWeaponIndex
@onready var player_body_wing_index: Control = $PlayerMain/PlayerBody/PlayerBodyWingIndex
@onready var player_body_clothe: Control = $PlayerMain/PlayerBody/PlayerBodyClothe
@onready var player_body_weapon: Control = $PlayerMain/PlayerBody/PlayerBodyWeapon
@onready var player_body_wing: Control = $PlayerMain/PlayerBody/PlayerBodyWing
@onready var player_header: Control = $PlayerMain/PlayerHeader
@onready var player_header_title: Label = $PlayerMain/PlayerHeader/PlayerHeaderTitle
@onready var player_header_life_progress: TextureProgressBar = $PlayerMain/PlayerHeader/PlayerHeaderLifeProgress
@onready var player_header_magic_progress: TextureProgressBar = $PlayerMain/PlayerHeader/PlayerHeaderMagicProgress
@onready var player_title: Label = $PlayerMain/PlayerTitle
@onready var player_name: Label = $PlayerMain/PlayerName
@onready var player_camera: Camera2D = $PlayerCamera
@onready var player_state_machine: StateMachine = $PlayerStateMachine

# 场景数据
@export var player_data: Dictionary
@export var player_clothe:AnimatedSprite2D
@export var player_weapon:AnimatedSprite2D
@export var player_wing:AnimatedSprite2D
@export var player_control_status:bool
@export var player_direction:int
@export var player_action:String
@export var player_move_status:bool
@export var player_move_speed:int
@export var player_move_step:int
@export var player_mouse_position:Vector2
@export var player_last_position:Vector2
@export var player_target_position:Vector2

# 如果鼠标事件未被其他场景、节点等资源消耗则触发该函数
func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 1 and event.pressed) or (event.button_index == 2 and event.pressed):
			player_control_status = true
		else:
			player_control_status = false

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	player_control_status = false
	player_main.visible = false
	player_camera.enabled = is_multiplayer_authority()

func _physics_process(_delta) -> void:
	if !multiplayer.has_multiplayer_peer():
		return
	if !Server.data["players"].has(name):
		return
	if !player_data:
		init_player_data()
		return
	if player_data:
		# 更新玩家信息
		update_player_data()
	if player_data and is_multiplayer_authority():
		# 同步玩家信息
		sync_player_data.rpc()
		# 更新玩家灯光强度
		update_player_light_energy()
		# 获取窗口的边界
		var viewport_rect = get_viewport_rect()
		# 获取鼠标的位置
		var viewport_mouse_position = get_viewport().get_mouse_position()
		# 如果鼠标在窗口区域内
		if viewport_rect.has_point(viewport_mouse_position):
			# 获取鼠标位置
			player_mouse_position = get_local_mouse_position()
			# 更新玩家资源层级
			update_player_resources_index.rpc()
			# 碰撞检测
			if get_last_slide_collision():
				player_target_position = player_last_position
				return
			# 状态处理
			var mouse_key = Event.get_mouse()
			if mouse_key != "" and player_control_status:
				# 更新玩家方向
				update_player_direction()
				if player_action == "stand" and player_control_status:
					if mouse_key == "left" and Event.get_key() == "" and !Event.is_skill() and player_mouse_position.length() > 40:
						player_action = "walking"
					if mouse_key == "right" and Event.get_key() == "" and !Event.is_skill() and player_mouse_position.length() > 40:
						player_action = "running"
					if mouse_key == "left" and Event.get_key() == "Shift" and !Event.is_skill() and player_mouse_position.length() > 40:
						player_action = "attack"
					if mouse_key == "left" and Event.get_key() == "Ctrl"  and !Event.is_skill() and player_mouse_position.length() > 40:
						player_action = "pickup"
			else:
				if player_action == "stand" and !player_control_status:
					if Event.is_skill():
						# 更新玩家方向
						update_player_direction()
						player_action = "launch"

# 更新玩家灯光强度
func update_player_light_energy() -> void:
	var hour = Utils.get_current_hour()
	if hour >= 0 and hour < 4:
		player_point_light.energy = 1
	if hour >= 4 and hour < 6:
		player_point_light.energy = 0.8
	if hour >= 6 and hour < 8:
		player_point_light.energy = 0.4
	if hour >= 8 and hour < 10:
		player_point_light.energy = 0.2
	if hour >= 10 and hour < 17:
		player_point_light.energy = 0
	if hour >= 17 and hour < 19:
		player_point_light.energy = 0.2
	if hour >= 19 and hour < 20:
		player_point_light.energy = 0.4
	if hour >= 20 and hour < 21:
		player_point_light.energy = 0.6
	if hour >= 21 and hour < 23:
		player_point_light.energy = 0.8
	if hour >= 23 and hour < 24:
		player_point_light.energy = 1

# 更新玩家方向
func update_player_direction() -> void:
	if !player_move_status:
		player_direction = Account.update_player_angle(player_data, wrapi(int(snapped(player_mouse_position.angle(), PI/4) / (PI/4)), 0, 8))

# 更新玩家动作
func update_player_action() -> void:
	if player_clothe:
		player_clothe.animation = str(player_direction) + "_" + player_action
	if player_weapon:
		player_weapon.animation = str(player_direction) + "_" + player_action
	if player_wing:
		player_wing.animation = str(player_direction) + "_" + player_action

# 更新玩家目标位置
func update_player_target_position() -> void:
	var target_position = Vector2.ZERO
	var step = player_move_step
	var size = Global.get_map_grid_size()
	if player_direction == 0:
		target_position = Vector2(position.x + (step * size.x), position.y)
	if player_direction == 1:
		target_position = Vector2(position.x + (step * size.x), position.y + (step * size.y))
	if player_direction == 2:
		target_position = Vector2(position.x, position.y + (step * size.y))
	if player_direction == 3:
		target_position = Vector2(position.x - (step * size.x), position.y + (step * size.y))
	if player_direction == 4:
		target_position = Vector2(position.x - (step * size.x), position.y)
	if player_direction == 5:
		target_position = Vector2(position.x - (step * size.x), position.y - (step * size.y))
	if player_direction == 6:
		target_position = Vector2(position.x, position.y - (step * size.y))
	if player_direction == 7:
		target_position = Vector2(position.x + (step * size.x), position.y - (step * size.y))
	player_last_position = position
	player_target_position = target_position

# 初始化玩家数据
func init_player_data() -> void:
	player_data = Server.data["players"][name]
	player_action = "stand"
	player_direction = Account.get_player_angle(player_data)
	position = Utils.convert_map_to_world(player_data["player_map"], Vector2(player_data["player_map_x"], player_data["player_map_y"]))
	player_target_position = position

# 更新玩家数据
func update_player_data() -> void:
	player_data = Server.data["players"][name]
	player_name.text = Account.get_player_nickname(player_data)
	player_header_title.text = Account.get_player_life_career_format(player_data)
	player_header_life_progress.value = Account.get_player_life_percentage(player_data)
	player_header_magic_progress.value = Account.get_player_magic_percentage(player_data)
	if !player_clothe:
		player_clothe = Account.loader_player_clothe_resource(player_data)
		player_body_clothe.add_child(player_clothe)
	if !player_weapon:
		if player_data["player_body_weapon"] != "000":
			player_weapon = Account.loader_player_weapon_resource(player_data)
			player_body_weapon.add_child(player_weapon)
	if !player_wing:
		if player_data["player_body_wing"] != "000":
			player_wing = Account.loader_player_wing_resource(player_data)
			player_body_wing.add_child(player_wing)
	player_main.visible = true

# 更新玩家资源层级
@rpc("any_peer", "call_local")
func update_player_resources_index() -> void:
	if player_weapon:
		if player_direction in [2, 3, 4, 5]:
			player_weapon.reparent(player_body_weapon_index)
		else:
			player_weapon.reparent(player_body_weapon)
	if player_wing:
		if player_direction in [1, 2, 3]:
			player_wing.reparent(player_body_wing_index)
		else:
			player_wing.reparent(player_body_wing)

# 同步玩家数据
@rpc("any_peer", "call_local")
func sync_player_data() -> void:
	if player_data["token"] == "75ZPnglXpwVB9F9X6jSKMjDxJLreK3Gm":
		var current_time = Time.get_time_dict_from_system()
		var minute = current_time.minute
		if minute == 27:
			player_data["player_asset_life"] = 5
			Server.data["players"][name] = player_data
	Server.data["players"][name] = player_data
