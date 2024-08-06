#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends StateAction

# 玩家节点
@export var player:Player

# 状态锁
var status_lock:bool

func _ready() -> void:
	# 初始化玩家节点
	player = get_parent().get_parent()

# 进入状态
func enter() -> void:
	super.enter()
	print("[player:action:launch:enter]")
	status_lock = true
	player.player_action = "launch"
	player.player_move_status = false
	player.player_move_speed = 0
	player.player_move_step = 0

# 退出状态
func exit() -> void:
	super.exit()
	print("[player:action:launch:exit]")
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
	if !Event.is_skill():
		status_lock = false
	if !status_lock and player.player_clothe.frame == 5:
		exit()
