#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

class_name Monster extends CharacterBody2D

# 场景资源
@onready var monster: Monster = $"."
@onready var monster_collision: CollisionShape2D = $MonsterCollision
@onready var monster_main: Control = $MonsterMain

# 场景数据
@export var monster_data: Dictionary

func _ready() -> void:
	pass

func _physics_process(_delta) -> void:
	pass
