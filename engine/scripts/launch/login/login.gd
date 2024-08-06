#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var button_pressed_music: AudioStreamPlayer2D = $ButtonPressedMusic
@onready var default: Control = $Default
@onready var default_email: LineEdit = $Default/DefaultEmail
@onready var default_password: LineEdit = $Default/DefaultPassword
@onready var default_submit: TextureButton = $Default/DefaultSubmit
@onready var default_register: TextureButton = $Default/DefaultRegister
@onready var default_change: TextureButton = $Default/DefaultChange
@onready var register: Control = $Register
@onready var register_email: LineEdit = $Register/RegisterEmail
@onready var register_code: LineEdit = $Register/RegisterCode
@onready var register_code_label: Label = $Register/RegisterCodeLabel
@onready var register_code_timer: Timer = $Register/RegisterCodeLabel/RegisterCodeTimer
@onready var register_code_submit: TextureButton = $Register/RegisterCodeLabel/RegisterCodeSubmit
@onready var register_password: LineEdit = $Register/RegisterPassword
@onready var register_name: LineEdit = $Register/RegisterName
@onready var register_number: LineEdit = $Register/RegisterNumber
@onready var register_question_a: LineEdit = $Register/RegisterQuestionA
@onready var register_answer_a: LineEdit = $Register/RegisterAnswerA
@onready var register_question_b: LineEdit = $Register/RegisterQuestionB
@onready var register_answer_b: LineEdit = $Register/RegisterAnswerB
@onready var register_confirm_submit: TextureButton = $Register/RegisterConfirmSubmit
@onready var register_cancel_submit: TextureButton = $Register/RegisterCancelSubmit
@onready var change: Control = $Change
@onready var change_email: LineEdit = $Change/ChangeEmail
@onready var change_password: LineEdit = $Change/ChangePassword
@onready var change_new_password: LineEdit = $Change/ChangeNewPassword
@onready var change_confirm_password: LineEdit = $Change/ChangeConfirmPassword
@onready var change_confirm_submit: TextureButton = $Change/ChangeConfirmSubmit
@onready var change_cancel_submit: TextureButton = $Change/ChangeCancelSubmit

# 场景信号
signal switch_server_signal()

func _ready() -> void:
	default.visible = true
	register.visible = false
	change.visible = false
	default_email.grab_focus()

func _process(_delta: float) -> void:
	if register_code_submit.disabled:
		register_code_label.text = "%d" % register_code_timer.time_left

# # 登录表单回车事件函数
func _on_default_password_text_submitted(text: String) -> void:
	if text != "":
		default_submit.emit_signal("pressed")

# 登录按钮事件函数
func _on_default_submit_pressed() -> void:
	if !default_submit.disabled:
		print("[launch:login:default:submit]")
		_on_button_pressed_music()
		if default_email.text == "" || default_password.text == "":
			get_parent().on_dialog("登录信息不完整")
			return
		default_submit.disabled = true
		Request.on_server("/game/account/mail/login?email=" + default_email.text + "&password=" + default_password.text, HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					default_submit.disabled = false
					get_parent().on_dialog(response.message)
					return
				Account.update_token(response.data.token)
				_on_register_cancel_submit_pressed()
				_on_change_cancel_submit_pressed()
				default_email.text = ""
				default_password.text = ""
				default_submit.disabled = false
				switch_server_signal.emit()
			else:
				default_submit.disabled = false
				get_parent().on_dialog("账号登录失败")
		)

# 注册按钮事件函数
func _on_default_register_pressed() -> void:
	print("[launch:login:register]")
	_on_button_pressed_music()
	register.visible = true

# 获取验证码按钮事件函数
func _on_register_code_submit_pressed() -> void:
	if !register_code_submit.disabled:
		print("[launch:login:register:code:submit]")
		_on_button_pressed_music()
		if register_email.text == "":
			get_parent().on_dialog("请填写登录邮箱")
			return
		var check = Utils.check_mail_format(register_email.text)
		if !check:
			get_parent().on_dialog("邮箱格式不正确")
			return
		register_code_submit.disabled = true
		Request.on_server("/game/account/mail/code?mail=" + register_email.text, HTTPClient.METHOD_GET, {}, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					register_code_submit.disabled = false
					get_parent().on_dialog(response.message)
					return
				register_code_timer.start()
			else:
				register_code_submit.disabled = false
				get_parent().on_dialog("验证码发送失败")
		)

# 获取验证码倒计时结束事件信号
func _on_register_code_timer_timeout() -> void:
	print("[launch:login:register:code:timeout]")
	register_code_submit.disabled = false
	register_code_label.text = "获取验证码"

# 账号注册确定按钮事件函数
func _on_register_confirm_submit_pressed() -> void:
	if !register_confirm_submit.disabled:
		print("[launch:login:register:confirm:submit]")
		_on_button_pressed_music()
		if register_email.text == "" || register_code.text == "" || register_password.text == "":
			get_parent().on_dialog("注册信息不完整")
			return
		var check = Utils.check_mail_format(register_email.text)
		if !check:
			get_parent().on_dialog("邮箱格式不正确")
			return
		register_confirm_submit.disabled = true
		var register_data = {
			"mail": register_email.text,
			"code": register_code.text,
			"password": register_password.text,
			"name": register_name.text,
			"number": register_number.text,
			"question_a": register_question_a.text,
			"question_b": register_question_b.text,
			"answer_a": register_answer_a.text,
			"answer_b": register_answer_b.text,
		}
		Request.on_server("/game/account/mail/register", HTTPClient.METHOD_POST, register_data, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					register_confirm_submit.disabled = false
					get_parent().on_dialog(response.message)
					return
				get_parent().on_dialog("账号注册成功")
				_on_register_cancel_submit_pressed()
			else:
				register_confirm_submit.disabled = false
				get_parent().on_dialog("账号注册失败")
		)

# 账号注册取消按钮事件函数
func _on_register_cancel_submit_pressed() -> void:
	print("[launch:login:register:cancel]")
	_on_button_pressed_music()
	register.visible = false
	register_email.text = ""
	register_code.text = ""
	register_code_label.text = "获取验证码"
	register_code_submit.disabled = false
	register_password.text = ""
	register_name.text = ""
	register_number.text = ""
	register_question_a.text = ""
	register_answer_a.text = ""
	register_question_b.text = ""
	register_answer_b.text = ""
	register_code_submit.disabled = false
	register_confirm_submit.disabled = false

# 修改密码按钮事件函数
func _on_default_change_pressed() -> void:
	print("[launch:login:change]")
	_on_button_pressed_music()
	change.visible = true

# 修改密码确认按钮事件函数
func _on_change_confirm_submit_pressed() -> void:
	if !change_confirm_submit.disabled:
		print("[launch:login:change:confirm:submit]")
		_on_button_pressed_music()
		if change_email.text == "" || change_password.text == "" || change_new_password.text == "" || change_confirm_password.text == "":
			get_parent().on_dialog("账号信息不完整")
			return
		if change_new_password.text != change_confirm_password.text:
			get_parent().on_dialog("新密码输入不一致")
			return
		change_confirm_submit.disabled = true
		var change_password_data = {
			"mail": change_email.text,
			"password": change_password.text,
			"new_password": change_new_password.text
		}
		Request.on_server("/game/account/mail/change/password", HTTPClient.METHOD_POST, change_password_data, func(_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response.code != 0:
					change_confirm_submit.disabled = false
					get_parent().on_dialog(response.message)
					return
				get_parent().on_dialog("密码修改成功")
				_on_change_cancel_submit_pressed()
			else:
				change_confirm_submit.disabled = false
				get_parent().on_dialog("密码修改失败")
		)

# 修改密码取消按钮事件函数
func _on_change_cancel_submit_pressed() -> void:
	print("[launch:login:change:cancel]")
	_on_button_pressed_music()
	change.visible = false
	change_email.text = ""
	change_password.text = ""
	change_new_password.text = ""
	change_confirm_password.text = ""
	change_confirm_submit.disabled = false

# 公用按钮音效函数
func _on_button_pressed_music() -> void:
	button_pressed_music.play()
