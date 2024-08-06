#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node2D

# 场景资源
@onready var time_zone: CanvasModulate = $TimeZone
@onready var players: Node2D = $Players
@onready var monsters: Node2D = $Monsters
@onready var npcs: Node2D = $Npcs
@onready var skills: Node2D = $Skills

func _ready() -> void:
	pass
