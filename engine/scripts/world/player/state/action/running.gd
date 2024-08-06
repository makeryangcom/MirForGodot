#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends StateAction

# 玩家节点
@export var player:Player

func _ready() -> void:
	# 初始化玩家节点
	player = get_parent().get_parent()

# 进入状态
func enter() -> void:
	super.enter()
	print("[player:action:running:enter]")
	player.player_action = "running"
	player.player_move_status = true
	player.player_move_speed = 160
	player.player_move_step = 2

# 退出状态
func exit() -> void:
	super.exit()
	print("[player:action:running:exit]")
	state_machine.change_action("Stand")

# 渲染帧更新
func process_update(_delta: float) -> void:
	super.process_update(_delta)

# 物理帧更新
func physics_process_update(_delta: float) -> void:
	super.physics_process_update(_delta)
	# 更新玩家动作
	player.update_player_action()
	# 动作处理
	if player.position != player.player_target_position and player.player_move_speed > 0:
		player.velocity = player.position.direction_to(player.player_target_position) * player.player_move_speed
		if player.position.distance_squared_to(player.player_target_position) > 5:
			player.move_and_slide()
		else:
			player.position = player.player_target_position
			exit()
