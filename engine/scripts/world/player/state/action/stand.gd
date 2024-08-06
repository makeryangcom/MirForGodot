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
	print("[player:action:stand:enter]")
	player.player_action = "stand"
	player.player_move_status = false
	player.player_move_speed = 0
	player.player_move_step = 0

# 退出状态
func exit() -> void:
	super.exit()
	print("[player:action:stand:exit]")

# 渲染帧更新
func process_update(_delta: float) -> void:
	super.process_update(_delta)

# 物理帧更新
func physics_process_update(_delta: float) -> void:
	super.physics_process_update(_delta)
	# 更新玩家动作
	player.update_player_action()
	# 动作处理
	if player.player_action == "walking" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 更新玩家目标位置
		player.player_move_step = 1
		player.update_player_target_position()
		# 切换动作
		state_machine.change_action("Walking")
	if player.player_action == "running" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 更新玩家目标位置
		player.player_move_step = 2
		player.update_player_target_position()
		# 切换动作
		state_machine.change_action("Running")
	if player.player_action == "attack" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 切换状态
		player.player_move_step = 0
		state_machine.change_action("Attack")
	if player.player_action == "pickup" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 切换状态
		player.player_move_step = 0
		state_machine.change_action("Pickup")
	if player.player_action == "launch" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 切换状态
		player.player_move_step = 0
		state_machine.change_action("Launch")
	
