#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

class_name Interface extends CanvasLayer

# 场景资源
@onready var button_pressed_music: AudioStreamPlayer = $ButtonPressedMusic
@onready var weather: Node2D = $Weather
@onready var rain: Node2D = $Weather/Rain
@onready var snow: Node2D = $Weather/Snow
@onready var wind: Node2D = $Weather/Wind
@onready var cloud: Node2D = $Weather/Cloud
@onready var death_display: ColorRect = $DeathDisplay
@onready var footer_middle: Control = $FooterMiddle
@onready var dashboard_main: Control = $FooterMiddle/DashboardMain
@onready var top_right: Control = $TopRight
@onready var min_map: Control = $TopRight/MinMap
@onready var left_bottom: Control = $LeftBottom
@onready var chat_main: Control = $LeftBottom/ChatMain
@onready var popup: Control = $Popup
@onready var package_main: Control = $Popup/PackageMain
@onready var store_main: Control = $Popup/StoreMain
@onready var panel_main: Control = $Popup/PanelMain
@onready var max_main: Control = $Popup/MaxMain

# 场景数据
@export var player_data: Dictionary
@export var players_node: Node2D
@export var player_node: Player
@export var world_node: World
@export var popup_index: int
@export var is_chat: bool

func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			print(event.as_text_keycode())
			if event.as_text_keycode() in ["F9", "F10", "F11", "F12"] and !chat_main.chat_input.has_focus():
				if event.as_text_keycode() == "F9":
					_on_popup_on_click_signal("PackageMain", true)
				if event.as_text_keycode() == "F10":
					_on_popup_on_click_signal("PanelMain", true)
			if event.as_text_keycode() in ["Tab"] and !chat_main.chat_input.has_focus():
				min_map.on_scale_map()
			if event.as_text_keycode() in ["M"] and !chat_main.chat_input.has_focus():
				_on_popup_on_click_signal("MaxMain", true)
			if event.as_text_keycode() in ["Space"] and !chat_main.chat_input.has_focus():
				if !is_chat:
					chat_main.on_show()
					is_chat = true
			if event.as_text_keycode() in ["Enter"]:
				if is_chat:
					chat_main.on_send_message()
					is_chat = false

func _ready() -> void:
	is_chat = false
	death_display.visible = false
	popup.visible = false

func _process(_delta: float) -> void:
	if Server.data["players"].has(str(Client.get_client_id())) and multiplayer.has_multiplayer_peer():
		world_node = get_parent()
		player_data = Server.data["players"][str(Client.get_client_id())]
		players_node = get_parent().get_node("Main").get_node(player_data["player_map"]).get_node("Players")
		if players_node.has_node(str(Client.get_client_id())):
			player_node = players_node.get_node(str(Client.get_client_id()))
			if player_data:
				popup.visible = true
				# 渲染小地图
				if !min_map.min_map_main_viewport.has_node("MinMapView"):
					var min_map_scene = load(Account.get_player_map_path(player_data)).instantiate()
					min_map_scene.name = "MinMapView"
					min_map_scene.set_process(false)
					min_map.min_map_main_viewport.add_child(min_map_scene)
					min_map.min_map_main_viewport.move_child(min_map_scene, 0)
				# 更新小地图相机实时位置
				min_map.min_map_main_viewport_camera.position = player_node.position
				# 更新小地图人物定位图标位置
				min_map.min_map_main_viewport_location.position = player_node.position
				# 渲染大地图
				if !max_main.main_viewport.has_node("MaxMapView"):
					var max_map_scene = load(Account.get_player_map_path(player_data)).instantiate()
					max_map_scene.name = "MaxMapView"
					max_map_scene.set_process(false)
					max_map_scene.position = Vector2(-12024, -8016)
					max_main.main_viewport.add_child(max_map_scene)
					max_main.main_viewport.move_child(max_map_scene, 0)
				if max_main.visible:
					# 更新大地图人物定位图标位置
					max_main.main_viewport_location.position = Vector2(player_node.position.x - 12024, player_node.position.y - 8016)

# 更新玩家数据函数
func update_player_data() -> Dictionary:
	return player_data

# 弹出层层级切换事件函数
func _on_popup_on_click_signal(type: String, source: bool) -> void:
	print("[interface:popup:on:click:signal] ", type)
	if type == "ScaleMinMap":
		min_map.on_scale_map()
		return
	if type == "PanelMain":
		panel_main.current_tab = "equip"
	if type == "PanelSkillMain":
		panel_main.current_tab = "skill"
		type = "PanelMain"
	if type == "PanelAttributeMain":
		panel_main.current_tab = "attribute"
		type = "PanelMain"
	if type == "PanelStateMain":
		panel_main.current_tab = "state"
		type = "PanelMain"
	for i in range(popup.get_child_count()):
		if popup.get_child(i).name == type:
			if popup.get_child(i).visible:
				if source:
					popup.get_child(i).visible = false
				else:
					popup_index = popup_index + 1
					popup.get_child(i).z_index = popup_index
			else:
				popup_index = popup_index + 1
				popup.get_child(i).z_index = popup_index
				popup.get_child(i).visible = true

# 退出游戏事件函数
func _on_out_game_pressed() -> void:
	print("[interface:on:out:game]")
	world_node.main.visible = false
	world_node.interface.visible = false
	multiplayer.multiplayer_peer = null
	Client.on_close()
	get_tree().quit()

func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("[interface:notification:NOTIFICATION_WM_CLOSE_REQUEST]")
		# 阻止默认退出事件
		get_tree().set_auto_accept_quit(false)
		# 弹窗确认
		_on_out_game_pressed()

# 公用按钮音效函数
func on_button_pressed_music() -> void:
	print("[interface:button:pressed:music]")
	button_pressed_music.play()
