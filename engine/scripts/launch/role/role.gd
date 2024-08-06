#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var button_pressed_music: AudioStreamPlayer2D = $ButtonPressedMusic
@onready var character: Control = $Character
@onready var character_box: Control = $Character/CharacterBox
@onready var character_describe: Control = $Character/CharacterDescribe
@onready var character_switch: Control = $Character/CharacterSwitch
@onready var left_switch: TextureButton = $Character/CharacterSwitch/LeftSwitch
@onready var right_switch: TextureButton = $Character/CharacterSwitch/RightSwitch
@onready var warrior_men: AnimatedSprite2D = $Character/CharacterBox/WarriorMen
@onready var warrior_women: AnimatedSprite2D = $Character/CharacterBox/WarriorWomen
@onready var mage_men: AnimatedSprite2D = $Character/CharacterBox/MageMen
@onready var mage_women: AnimatedSprite2D = $Character/CharacterBox/MageWomen
@onready var taoist_men: AnimatedSprite2D = $Character/CharacterBox/TaoistMen
@onready var taoist_women: AnimatedSprite2D = $Character/CharacterBox/TaoistWomen
@onready var warrior_describe: TextureRect = $Character/CharacterDescribe/WarriorDescribe
@onready var mage_describe: TextureRect = $Character/CharacterDescribe/MageDescribe
@onready var taoist_describe: TextureRect = $Character/CharacterDescribe/TaoistDescribe
@onready var left: Control = $Left
@onready var left_level: Label = $Left/LeftLevel
@onready var left_name: Label = $Left/LeftName
@onready var left_career: Label = $Left/LeftCareer
@onready var left_gender: Label = $Left/LeftGender
@onready var right: Control = $Right
@onready var create_button: TextureButton = $Right/CreateButton
@onready var restore_button: TextureButton = $Right/RestoreButton
@onready var delete_button: TextureButton = $Right/DeleteButton
@onready var return_button: TextureButton = $Right/ReturnButton
@onready var bottom: Control = $Bottom
@onready var create: Control = $Bottom/Create
@onready var nickname: LineEdit = $Bottom/Create/Top/Nickname
@onready var men_button: TextureButton = $Bottom/Create/Middle/MenButton
@onready var women_button: TextureButton = $Bottom/Create/Middle/WomenButton
@onready var create_confirm_button: TextureButton = $Bottom/Create/Footer/CreateConfirmButton
@onready var create_cancel_button: TextureButton = $Bottom/Create/Footer/CreateCancelButton
@onready var start: Control = $Bottom/Start
@onready var start_button: TextureButton = $Bottom/Start/StartButton

@onready var delete_dialog: Control = $DeleteDialog
@onready var dialog_confirm_button: TextureButton = $DeleteDialog/DialogConfirmButton
@onready var dialog_cancel_button: TextureButton = $DeleteDialog/DialogCancelButton

# 场景信号
signal switch_login_signal()
signal switch_world_signal()

# 场景数据
var type:String = ""
var role_array: Array
var role_int:int = 0
var gender:int = 0
var gender_array: Array = ["men", "women"]
var career:int = 0
var career_array: Array = [
	{"career": "warrior", "name": "战士"},
	{"career": "mage", "name": "法师"},
	{"career": "taoist", "name": "道士"}
]

func _ready() -> void:
	type = ""
	role_array = []
	role_int = 0
	gender = 0
	career = 0
	character_box.visible = false
	warrior_men.visible = false
	warrior_women.visible = false
	mage_men.visible = false
	mage_women.visible = false
	taoist_men.visible = false
	taoist_women.visible = false
	character_describe.visible = false
	warrior_describe.visible = false
	mage_describe.visible = false
	taoist_describe.visible = false
	character_switch.visible = false
	left.visible = false
	right.visible = true
	create.visible = false
	start.visible = true
	start_button.disabled = true
	delete_dialog.visible = false

func _process(_delta: float) -> void:
	if type == "":
		if len(role_array) > 0:
			left.visible = true
			character_box.visible = true
			character_switch.visible = true
			start_button.disabled = false
			var select_role = role_array[role_int]
			for i in range(len(career_array)):
				if career_array[i]["career"] == select_role["player_career"]:
					career = i
					var gender_string: String = ""
					if select_role["player_gender"] == "men":
						gender = 0
						gender_string = "男"
					if select_role["player_gender"] == "women":
						gender = 1
						gender_string = "女"
					left_level.text = "Level." + str(select_role["player_asset_level"])
					left_name.text = select_role["player_nickname"]
					left_career.text = career_array[i]["name"]
					left_gender.text = gender_string
			if career == 0:
				warrior_describe.visible = true
				mage_describe.visible = false
				taoist_describe.visible = false
				mage_men.visible = false
				mage_women.visible = false
				taoist_men.visible = false
				taoist_women.visible = false
				if gender == 0:
					warrior_men.visible = true
					warrior_women.visible = false
				if gender == 1:
					warrior_men.visible = false
					warrior_women.visible = true
			if career == 1:
				warrior_describe.visible = false
				mage_describe.visible = true
				taoist_describe.visible = false
				warrior_men.visible = false
				warrior_women.visible = false
				taoist_men.visible = false
				taoist_women.visible = false
				if gender == 0:
					mage_men.visible = true
					mage_women.visible = false
				if gender == 1:
					mage_men.visible = false
					mage_women.visible = true
			if career == 2:
				warrior_describe.visible = false
				mage_describe.visible = false
				taoist_describe.visible = true
				warrior_men.visible = false
				warrior_women.visible = false
				mage_men.visible = false
				mage_women.visible = false
				if gender == 0:
					taoist_men.visible = true
					taoist_women.visible = false
				if gender == 1:
					taoist_men.visible = false
					taoist_women.visible = true
		else:
			start_button.disabled = true
	if type == "create":
		left.visible = false
		if career == 0:
			warrior_describe.visible = true
			mage_describe.visible = false
			taoist_describe.visible = false
			mage_men.visible = false
			mage_women.visible = false
			taoist_men.visible = false
			taoist_women.visible = false
			if gender == 0:
				warrior_men.visible = true
				warrior_women.visible = false
			if gender == 1:
				warrior_men.visible = false
				warrior_women.visible = true
		if career == 1:
			warrior_describe.visible = false
			mage_describe.visible = true
			taoist_describe.visible = false
			warrior_men.visible = false
			warrior_women.visible = false
			taoist_men.visible = false
			taoist_women.visible = false
			if gender == 0:
				mage_men.visible = true
				mage_women.visible = false
			if gender == 1:
				mage_men.visible = false
				mage_women.visible = true
		if career == 2:
			warrior_describe.visible = false
			mage_describe.visible = false
			taoist_describe.visible = true
			warrior_men.visible = false
			warrior_women.visible = false
			mage_men.visible = false
			mage_women.visible = false
			if gender == 0:
				taoist_men.visible = true
				taoist_women.visible = false
			if gender == 1:
				taoist_men.visible = false
				taoist_women.visible = true

func on_role(_server_token: String) -> void:
	if _server_token != "":
		print("[launch:role:on_role]")
		_ready()
		Request.on_server("/game/player/index?token=" + _server_token, HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					get_parent().on_dialog(response.message)
					return
				role_array = Global.update_server_role(response.data.player)
				Account.update_area_token(_server_token)
			else:
				get_parent().on_dialog("服务区人物角色失败")
		)

# 开始游戏按钮事件函数
func _on_start_button_pressed() -> void:
	if len(role_array) > 0:
		print("[launch:role:start:button]")
		_on_button_pressed_music()
		await get_tree().create_timer(0.2).timeout
		var player = Account.update_player(role_array[role_int])
		if player["token"] == "":
			get_parent().on_dialog("开始游戏失败")
			return
		start_button.disabled = true
		switch_world_signal.emit()
		start_button.disabled = false

# 创建角色性别男按钮事件函数
func _on_men_button_pressed() -> void:
	if type == "create":
		print("[launch:role:men:button]")
		_on_button_pressed_music()
		gender = 0
		men_button.button_pressed = true
		women_button.button_pressed = false

# 创建角色性别女按钮事件函数
func _on_women_button_pressed() -> void:
	if type == "create":
		print("[launch:role:women:button]")
		_on_button_pressed_music()
		gender = 1
		women_button.button_pressed = true
		men_button.button_pressed = false

# 创建角色提交按钮事件函数
func _on_create_confirm_button_pressed() -> void:
	if type == "create":
		print("[launch:role:create:confirm:button]")
		_on_button_pressed_music()
		if nickname.text == "":
			get_parent().on_dialog("昵称不能为空")
			return
		create_confirm_button.disabled = true
		var player_data = {
			"token": Account.get_area_token(),
			"nickname": nickname.text,
			"gender":  gender_array[gender],
			"career": career_array[career]["career"]
		}
		Request.on_server("/game/player/create", HTTPClient.METHOD_POST, player_data, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					get_parent().on_dialog(response.message)
					return
				get_parent().on_dialog("人物角色创建成功")
				on_role(Account.get_area_token())
				role_int = 0
				create_confirm_button.disabled = false
				_on_create_cancel_button_pressed()
			else:
				create_confirm_button.disabled = false
				get_parent().on_dialog("人物角色创建失败")
		)

# 创建角色取消按钮事件函数
func _on_create_cancel_button_pressed() -> void:
	if type == "create":
		print("[launch:role:create:cancel:button]")
		_on_button_pressed_music()
		type = ""
		gender = 0
		career = 0
		nickname.text = ""
		create_confirm_button.disabled = false
		men_button.button_pressed = true
		women_button.button_pressed = false
		left_switch.disabled = false
		right_switch.disabled = false
		create.visible = false
		start.visible = true
		character_box.visible = false
		character_describe.visible = false
		character_switch.visible = false

# 右侧创建角色按钮事件函数
func _on_create_button_pressed() -> void:
	if type != "create":
		print("[launch:role:create:button]")
		_on_button_pressed_music()
		if len(role_array) == 6:
			get_parent().on_dialog("最多可创建6个人物角色")
			return
		type = "create"
		gender = 0
		career = 0
		nickname.text = ""
		start.visible = false
		create.visible = true
		character_box.visible = true
		character_describe.visible = true
		character_switch.visible = true
		men_button.button_pressed = true
		women_button.button_pressed = false

# 右侧恢复角色按钮事件函数
func _on_restore_button_pressed() -> void:
	if type != "create":
		print("[launch:role:restore:button]")
		_on_button_pressed_music()
		get_parent().on_dialog("功能尚未开放")

# 右侧返回按钮事件函数
func _on_return_button_pressed() -> void:
	if type != "create":
		print("[launch:role:return:button]")
		_on_button_pressed_music()
		switch_login_signal.emit()

# 右侧删除角色按钮事件函数
func _on_delete_button_pressed() -> void:
	if type != "create":
		print("[launch:role:delete:button]")
		_on_button_pressed_music()
		delete_dialog.visible = true

# 删除角色弹窗确认按钮事件函数
func _on_dialog_confirm_button_pressed() -> void:
	if len(role_array) > 0 and delete_dialog.visible:
		print("[launch:role:dialog:confirm:button]")
		_on_button_pressed_music()
		delete_dialog.visible = false
		var select_role = role_array[role_int]
		Request.on_server("/game/player/delete?token=" + select_role["token"], HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					get_parent().on_dialog(response.message)
					return
				role_array.remove_at(role_int)
				role_int = 0
				left_switch.disabled = true
				right_switch.disabled = false
			else:
				create_confirm_button.disabled = false
				get_parent().on_dialog("人物角色删除失败")
		)

# 删除角色弹窗取消按钮事件函数
func _on_dialog_cancel_button_pressed() -> void:
	if delete_dialog.visible:
		print("[launch:role:dialog:cancel:button]")
		_on_button_pressed_music()
		delete_dialog.visible = false

# 中间左侧切换职业按钮事件函数
func _on_left_switch_pressed() -> void:
	print("[launch:role:left:switch]")
	_on_button_pressed_music()
	if type == "create":
		career = career - 1
		if career == 0:
			left_switch.disabled = true
		else:
			left_switch.disabled = false
		right_switch.disabled = false
	else:
		if role_int == 0:
			role_int = 0
			left_switch.disabled = true
		else:
			role_int = role_int - 1
			left_switch.disabled = false
		right_switch.disabled = false

# 中间右侧切换职业按钮事件函数
func _on_right_switch_pressed() -> void:
	print("[launch:role:right:switch]")
	_on_button_pressed_music()
	if type == "create":
		career = career + 1
		if career == 2:
			right_switch.disabled = true
		else:
			right_switch.disabled = false
		left_switch.disabled = false
	else:
		if role_int == (len(role_array) - 1):
			role_int = (len(role_array) - 1)
			right_switch.disabled = true
		else:
			role_int = role_int + 1
			right_switch.disabled = false
		left_switch.disabled = false

# 公用按钮音效函数
func _on_button_pressed_music() -> void:
	button_pressed_music.play()
