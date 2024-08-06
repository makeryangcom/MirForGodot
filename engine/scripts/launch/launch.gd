#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic
@onready var login: Control = $Login
@onready var server: Control = $Server
@onready var role: Control = $Role
@onready var dialog: Control = $Dialog
@onready var dialog_message: Label = $Dialog/DialogMessage
@onready var version: Label = $Version

# 场景预加载资源
@onready var login_background_music: AudioStream = preload("res://assets/common/music/launch.wav")
@onready var server_background_music: AudioStream = preload("res://assets/common/music/launch_server.wav")
@onready var role_background_music: AudioStream = preload("res://assets/common/music/launch_role.wav")
@onready var world_scenes: PackedScene = preload("res://scenes/world/world.tscn")

func _ready() -> void:
	version.text = "VERSION:" + Global.get_version()
	background_music.stream = login_background_music
	background_music.play()
	login.visible = true
	server.visible = false
	role.visible = false
	dialog.visible = false
	if Global.is_server():
		await get_tree().create_timer(0.5).timeout
		_on_role_switch_world_signal()
		

func _on_role_switch_login_signal() -> void:
	print("[launch:role:switch:login:signal]")
	Account.update_token("")
	background_music.stream = login_background_music
	background_music.play()
	login.visible = true
	server.visible = false
	role.visible = false
	dialog.visible = false

func _on_login_switch_server_signal() -> void:
	print("[launch:login:switch:server:signal]")
	background_music.stream = server_background_music
	background_music.play()
	server.on_server()
	login.visible = false
	server.visible = true
	role.visible = false

func _on_server_switch_role_signal(_token: String) -> void:
	print("[launch:server:switch:role:signal]")
	background_music.stream = role_background_music
	background_music.play()
	role.on_role(_token)
	login.visible = false
	server.visible = false
	role.visible = true

func _on_role_switch_world_signal() -> void:
	print("[launch:role:switch:world:signal]")
	get_tree().change_scene_to_packed(world_scenes)

func on_dialog(message: String) -> void:
	print("[launch:on_dialog]")
	dialog_message.text = message
	dialog.visible = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(dialog, "visible", false, 0.5).set_delay(2)

func _on_background_music_finished() -> void:
	print("[launch:background:music:finished]")
	background_music.play()
