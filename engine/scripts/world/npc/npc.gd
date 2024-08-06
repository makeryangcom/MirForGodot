#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

class_name Npc extends CharacterBody2D

# 场景资源
@onready var npc: Npc = $"."
@onready var npc_collision: CollisionShape2D = $NpcCollision

# 场景数据
@export var npc_data: Dictionary

func _ready() -> void:
	pass

func _physics_process(_delta) -> void:
	pass
