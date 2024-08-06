#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************

extends Node

# 数据结构
var data = {
	"account": {
		"token": "",
		"area_token": "",
		"player": {}
	}
}

# 获取用户Token
func get_token() -> String:
	return data["account"]["token"]
	
# 更新并返回用户Token
func update_token(token: String) -> String:
	data["account"]["token"] = token
	return data["account"]["token"]

# 获取用户服务区Token
func get_area_token() -> String:
	return data["account"]["area_token"]
	
# 更新并返回用户Token
func update_area_token(token: String) -> String:
	data["account"]["area_token"] = token
	return data["account"]["area_token"]

# 获取用户玩家角色信息
func get_player() -> Dictionary:
	return data["account"]["player"]
	
# 更新并返回用户玩家角色信息
func update_player(player: Dictionary) -> Dictionary:
	data["account"]["player"] = player
	return data["account"]["player"]

# 获取用户玩家角色Token信息
func get_player_token() -> String:
	return data["account"]["player"]["token"]

# 获取玩家昵称数据
func get_player_nickname(player: Dictionary) -> String:
	return player["player_nickname"]

# 获取玩家性别数据
func get_player_gender(player: Dictionary) -> String:
	return player["player_gender"]

# 获取玩家余额数据
func get_player_balance(player: Dictionary) -> String:
	return player["player_balance"]

# 获取玩家积分数据
func get_player_integral(player: Dictionary) -> String:
	return player["player_integral"]

# 获取玩家等级数据
func get_player_level(player: Dictionary) -> int:
	return player["player_asset_level"]

# 获取玩家角度
func get_player_angle(player: Dictionary) -> int:
	return player["player_angle"]

# 更新并返回玩家角度
func update_player_angle(player: Dictionary, angle: int) -> int:
	player["player_angle"] = angle
	return player["player_angle"]

# 获取玩家生命值数据
func get_player_life(player: Dictionary) -> int:
	return player["player_asset_life"]

# 获取玩家生命值百分比数据
func get_player_life_percentage(player: Dictionary) -> float:
	return (float(player["player_asset_life"]) / float(player["player_asset_life_max"])) * 100

# 获取玩家生命值格式化数据
func get_player_life_format(player: Dictionary) -> String:
	return str(player["player_asset_life"]) + "/" + str(player["player_asset_life_max"])

# 获取玩家魔法值数据
func get_player_magic(player: Dictionary) -> int:
	return player["player_asset_magic"]

# 获取玩家魔法值百分比数据
func get_player_magic_percentage(player: Dictionary) -> float:
	return (float(player["player_asset_magic"]) / float(player["player_asset_magic_max"])) * 100

# 获取玩家魔法值格式化数据
func get_player_magic_format(player: Dictionary) -> String:
	return str(player["player_asset_magic"]) + "/" + str(player["player_asset_magic_max"])

# 获取玩家负重数据
func get_player_weight(player: Dictionary) -> int:
	return player["player_asset_weight"]

# 获取玩家负重百分比数据
func get_player_weight_percentage(player: Dictionary) -> float:
	return (float(player["player_asset_weight"]) / float(player["player_asset_weight_max"])) * 100

# 获取玩家负重格式化数据
func get_player_weight_format(player: Dictionary) -> String:
	return str(player["player_asset_weight"]) + "/" + str(player["player_asset_weight_max"])

# 获取玩家经验值数据
func get_player_experience(player: Dictionary) -> int:
	return player["player_asset_experience"]

# 获取玩家经验值百分比数据
func get_player_experience_percentage(player: Dictionary) -> float:
	return (float(player["player_asset_experience"]) / float(player["player_asset_experience_max"])) * 100

# 获取玩家经验值格式化数据
func get_player_experience_format(player: Dictionary) -> String:
	return str(player["player_asset_experience"]) + "/" + str(player["player_asset_experience_max"])

# 获取玩家生命值与职业格式化数据
func get_player_life_career_format(player: Dictionary) -> String:
	var career_level = ""
	if player["player_career"] == "warrior":
		career_level = "/Z" + str(player["player_asset_level"])
	if player["player_career"] == "mage":
		career_level = "/M" + str(player["player_asset_level"])
	if player["player_career"] == "taoist":
		career_level = "/T" + str(player["player_asset_level"])
	return str(player["player_asset_life"]) + "/" + str(player["player_asset_life_max"]) + career_level

# 获取玩家地图编号数据
func get_player_map_id(player: Dictionary) -> String:
	return player["player_map"]

# 获取玩家地图名称数据
func get_player_map_name(player: Dictionary) -> String:
	return player["player_map_name"]

# 获取玩家地图资源路径数据
func get_player_map_path(player: Dictionary) -> String:
	return Global.get_map_root_path() + player["player_map"] + "/" + player["player_map"] + ".tscn"

# 获取玩家服饰在原编号数据
func get_player_clothe_id(player: Dictionary) -> String:
	return player["player_body_clothe"]

# 获取玩家服饰资源路径数据
func get_player_clothe_path(player: Dictionary) -> String:
	return Global.get_clothe_root_path() + player["player_body_clothe"] + "/" + player["player_gender"] + ".tscn"

# 获取玩家服饰资源数据
func loader_player_clothe_resource(player: Dictionary) -> AnimatedSprite2D:
	var clothe_path = get_player_clothe_path(player)
	var clothe_loader = load(clothe_path).instantiate()
	clothe_loader.name = "Clothe"
	clothe_loader.speed_scale = Global.get_resource_speed_scale()
	return clothe_loader

# 获取玩家武器资源编号数据
func get_player_weapon_id(player: Dictionary) -> String:
	return player["player_body_weapon"]

# 获取玩家武器资源路径数据
func get_player_weapon_path(player: Dictionary) -> String:
	return Global.get_weapon_root_path() + player["player_body_weapon"] + "/" + player["player_gender"] + ".tscn"

# 获取玩家武器资源数据
func loader_player_weapon_resource(player: Dictionary) -> AnimatedSprite2D:
	var weapon_path = get_player_weapon_path(player)
	var weapon_loader = load(weapon_path).instantiate()
	weapon_loader.name = "Weapon"
	weapon_loader.speed_scale = Global.get_resource_speed_scale()
	return weapon_loader

# 获取玩家翅膀资源编号数据
func get_player_wing_id(player: Dictionary) -> String:
	return player["player_body_wing"]

# 获取玩家翅膀资源路径数据
func get_player_wing_path(player: Dictionary) -> String:
	return Global.get_wing_root_path() + player["player_body_wing"] + "/" + player["player_gender"] + ".tscn"

# 获取玩家翅膀资源数据
func loader_player_wing_resource(player: Dictionary) -> AnimatedSprite2D:
	var wing_path = get_player_wing_path(player)
	var wing_loader = load(wing_path).instantiate()
	wing_loader.name = "Wing"
	wing_loader.speed_scale = Global.get_resource_speed_scale()
	return wing_loader
