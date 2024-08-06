#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

class_name StateMachine extends Node2D

# 默认状态
@export var current_action:StateAction

func _ready() -> void:
	# 设置节点中所有子节点的状态机
	for child in get_children():
		if child is StateAction:
			child.state_machine = self
	# 等待父节点就绪
	await get_parent().ready
	# 默认进入第一个状态
	current_action = get_child(0)
	current_action.enter()

# 渲染帧更新
func _process(_delta: float) -> void:
	current_action.process_update(_delta)

# 物理帧更新
func _physics_process(_delta: float) -> void:
	current_action.physics_process_update(_delta)

# 切换状态
func change_action(target_action_name: String) -> void:
	# 获取目标状态节点
	var target_action = get_node_or_null(target_action_name)
	if target_action == null:
		return
	# 切换更新目标状态
	# current_action.exit()
	current_action = target_action
	current_action.enter()
