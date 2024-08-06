#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Control

# 场景资源
@onready var dashboard_main: Control = $"."
@onready var footer_left_time_image: TextureRect = $FooterLeft/FooterLeftTime/FooterLeftTimeImage
@onready var footer_left_time_data: Label = $FooterLeft/FooterLeftTime/FooterLeftTimeData
@onready var footer_centre_round_left: TextureProgressBar = $FooterCentre/FooterCentreRound/FooterCentreRoundLeft
@onready var footer_centre_round_right: TextureProgressBar = $FooterCentre/FooterCentreRound/FooterCentreRoundRight
@onready var footer_centre_animation: AnimatedSprite2D = $FooterCentre/FooterCentreRound/FooterCentreAnimation
@onready var footer_data_level: Label = $FooterCentre/FooterData/FooterDataLevel
@onready var footer_data_hp: Label = $FooterCentre/FooterData/FooterDataHP
@onready var footer_data_mp: Label = $FooterCentre/FooterData/FooterDataMP
@onready var footer_bottom_weight: TextureProgressBar = $FooterBottom/FooterBottomWeight
@onready var footer_bottom_experience: TextureProgressBar = $FooterBottom/FooterBottomExperience
@onready var map_button: TextureButton = $FooterRight/FooterRighTopIcon/MapButton
@onready var guild_button: TextureButton = $FooterRight/FooterRighTopIcon/GuildButton
@onready var transaction_button: TextureButton = $FooterRight/FooterRighTopIcon/TransactionButton
@onready var team_button: TextureButton = $FooterRight/FooterRighTopIcon/TeamButton
@onready var friend_button: TextureButton = $FooterRight/FooterRighTopIcon/FriendButton
@onready var challenge_button: TextureButton = $FooterRight/FooterRighTopIcon/ChallengeButton
@onready var out_role_button: TextureButton = $FooterRight/FooterRighTopIcon/OutRoleButton
@onready var out_game_button: TextureButton = $FooterRight/FooterRighTopIcon/OutGameButton
@onready var equipment_button: TextureButton = $FooterRight/FooterRightBottomIcon/EquipmentButton
@onready var backpack_button: TextureButton = $FooterRight/FooterRightBottomIcon/BackpackButton
@onready var skill_button: TextureButton = $FooterRight/FooterRightBottomIcon/SkillButton
@onready var attribute_button: TextureButton = $FooterRight/FooterRightBottomIcon/AttributeButton
@onready var state_button: TextureButton = $FooterRight/FooterRightBottomIcon/StateButton
@onready var ranking_button: TextureButton = $FooterRight/FooterRightBottomIcon/RankingButton
@onready var store_button: TextureButton = $FooterRight/FooterRightBottomIcon/StoreButton
@onready var footer_right_volume_button: TextureButton = $FooterRight/FooterRightVolumeButton
@onready var footer_right_mode_data: Label = $FooterRight/FooterRightMode/FooterRightModeData
@onready var footer_right_mode_button: TextureButton = $FooterRight/FooterRightMode/FooterRightModeButton

# 场景信号
signal on_click_signal(type: String, source: bool)

# 场景数据
var parent_node: CanvasLayer

func _ready() -> void:
	parent_node = get_parent().get_parent()

func _process(_delta: float) -> void:
	if parent_node and parent_node.player_data:
		footer_left_time_image.texture = Utils.get_current_time_image()
		footer_left_time_data.text = Utils.get_current_time()
		footer_data_level.text = str(Account.get_player_level(parent_node.player_data))
		footer_centre_round_left.value = Account.get_player_life_percentage(parent_node.player_data)
		footer_centre_round_right.value = Account.get_player_magic_percentage(parent_node.player_data)
		if footer_centre_round_left.value == 100 and footer_centre_round_right.value == 100:
			footer_centre_animation.visible = true
		else:
			footer_centre_animation.visible = false
		footer_data_hp.text = Account.get_player_life_format(parent_node.player_data)
		footer_data_mp.text = Account.get_player_magic_format(parent_node.player_data)
		footer_bottom_weight.value = Account.get_player_weight_percentage(parent_node.player_data)
		footer_bottom_weight.tooltip_text = Account.get_player_weight_format(parent_node.player_data)
		footer_bottom_experience.value = Account.get_player_experience_percentage(parent_node.player_data)
		footer_bottom_experience.tooltip_text = Account.get_player_experience_format(parent_node.player_data)

func _on_backpack_button_pressed() -> void:
	on_click_signal.emit("PackageMain", true)

func _on_equipment_button_pressed() -> void:
	on_click_signal.emit("PanelMain", true)

func _on_skill_button_pressed() -> void:
	on_click_signal.emit("PanelSkillMain", true)

func _on_attribute_button_pressed() -> void:
	on_click_signal.emit("PanelAttributeMain", true)

func _on_state_button_pressed() -> void:
	on_click_signal.emit("PanelStateMain", true)

func _on_ranking_button_pressed() -> void:
	on_click_signal.emit("RankingMain", true)

func _on_store_button_pressed() -> void:
	on_click_signal.emit("StoreMain", true)

func _on_map_button_pressed() -> void:
	on_click_signal.emit("ScaleMinMap", true)
