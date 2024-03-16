#*****************************************************************************
# @file    launch.gd
# @author  MakerYang(https://www.makeryang.com)
# @statement 免费课程配套开源项目，任何形式收费均为盗版
#*****************************************************************************
extends Control

@onready var login: Control = $Login
@onready var main: Control = $Login/Main
@onready var main_submit_button: TextureButton = $Login/Main/Background/MainSubmitButton
@onready var main_register_button: TextureButton = $Login/Main/Background/MainRegisterButton
@onready var main_change_password_button: TextureButton = $Login/Main/Background/MainChangePasswordButton
@onready var main_account_input: LineEdit = $Login/Main/Background/MainAccountInput
@onready var main_password_input: LineEdit = $Login/Main/Background/MainPasswordInput

@onready var register: Control = $Login/Register
@onready var register_confirm_button: TextureButton = $Login/Register/Background/RegisterConfirmButton
@onready var register_cancel_button: TextureButton = $Login/Register/Background/RegisterCancelButton
@onready var register_account_input: LineEdit = $Login/Register/Background/RegisterAccountInput
@onready var register_password_input: LineEdit = $Login/Register/Background/RegisterPasswordInput
@onready var register_confirm_password_input: LineEdit = $Login/Register/Background/RegisterConfirmPasswordInput
@onready var register_name_input: LineEdit = $Login/Register/Background/RegisterNameInput
@onready var register_number_input: LineEdit = $Login/Register/Background/RegisterNumberInput
@onready var register_question_a_input: LineEdit = $Login/Register/Background/RegisterQuestionAInput
@onready var register_answer_a_input: LineEdit = $Login/Register/Background/RegisterAnswerAInput
@onready var register_question_b_input: LineEdit = $Login/Register/Background/RegisterQuestionBInput
@onready var register_answer_b_input: LineEdit = $Login/Register/Background/RegisterAnswerBInput

@onready var change_password: Control = $Login/ChangePassword
@onready var change_password_confirm_button: TextureButton = $Login/ChangePassword/Background/ChangePasswordConfirmButton
@onready var change_password_cancel_button: TextureButton = $Login/ChangePassword/Background/ChangePasswordCancelButton
@onready var change_password_account_input: LineEdit = $Login/ChangePassword/Background/ChangePasswordAccountInput
@onready var change_password_old_input: LineEdit = $Login/ChangePassword/Background/ChangePasswordOldInput
@onready var change_password_new_input: LineEdit = $Login/ChangePassword/Background/ChangePasswordNewInput
@onready var change_password_confirm_input: LineEdit = $Login/ChangePassword/Background/ChangePasswordConfirmInput

@onready var server: Control = $Server
@onready var role: Control = $Role

func _ready() -> void:
	server.visible = false
	role.visible = false
	register.visible = false
	change_password.visible = false

func _process(delta: float) -> void:
	pass

func _on_main_register_button_pressed() -> void:
	register.visible = true

func _on_main_change_password_button_pressed() -> void:
	change_password.visible = true

func _on_register_cancel_button_pressed() -> void:
	register.visible = false

func _on_change_password_cancel_button_pressed() -> void:
	change_password.visible = false

func _on_register_confirm_button_pressed() -> void:
	if register_account_input.text == "" or register_password_input.text == "" or register_confirm_password_input.text == "":
		printerr("注册信息不完整")
		return
	if register_password_input.text != register_confirm_password_input.text:
		printerr("密码输入不一致")
		return
	print("开始请求后端接口")
	var post_data: Dictionary = {
		"account": register_password_input.text,
		"password": register_password_input.text,
		"name": register_name_input.text,
		"number": register_number_input.text,
		"question_a": register_question_a_input.text,
		"answer_a": register_answer_a_input.text,
		"question_b": register_question_b_input.text,
		"answer_b": register_answer_b_input.text,
	}
	print(post_data)
	Request.on_server("/account/register", HTTPClient.METHOD_POST, post_data, func(_result, code, _headers, body):
		if code == 200:
			var response = JSON.parse_string(body.get_string_from_utf8())
			print("[接口反馈数据]", response)
			if response["code"] == 0:
				print("接口请求成功")
			else:
				printerr("接口请求出错")
		else:
			printerr("接口异常")	
	)
