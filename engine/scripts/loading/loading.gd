#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var progress_bar: TextureProgressBar = $Progress/ProgressBar

func _ready() -> void:
	progress_bar.value = 0
