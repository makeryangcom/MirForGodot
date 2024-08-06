#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends CanvasModulate

# 场景资源
@onready var time_zone: CanvasModulate = $"."
@onready var animation: AnimationPlayer = $Animation

# 场景数据
@export var set_time_in_seconds: int

func _ready() -> void:
	set_time_in_seconds = 0

func _process(_delta: float) -> void:
	var time = Time.get_time_dict_from_system()
	var time_in_seconds = time.hour * 3600 + time.minute * 60 + time.second
	if set_time_in_seconds > 0:
		time_in_seconds = set_time_in_seconds
	var current_frame = remap(time_in_seconds, 0, 86400, 0, 24)
	animation.play("default")
	animation.seek(current_frame)
