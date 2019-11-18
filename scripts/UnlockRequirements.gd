extends Node

#
# Contains requirements needed to unlock players, accesories, etc.
#

enum UnlockType {
	PLAYER,
	ACCESSORY
}

enum UnlockRequirementType {
	HIGHSCORE,
	CUMULATIVE
}

const ACCESSORY_REQUIREMENTS = {
	Settings.Accessory.STRAW_HAT: 10,
	Settings.Accessory.NOOGLER: 20,
	Settings.Accessory.BURGER: 30,
	Settings.Accessory.CHEF: 40,
	Settings.Accessory.CROWN: 50,
	Settings.Accessory.MUSHROOM: 60,
	Settings.Accessory.RAINBOW: 70,
	Settings.Accessory.SANTA: 80
}

const PLAYER_REQUIREMENTS = {
	Settings.Player.DEFAULT: 0,
	Settings.Player.BLUE: 101,
	Settings.Player.ORANGE: 203,
	Settings.Player.PINK: 304,
	Settings.Player.PURPLE: 356,
	Settings.Player.TEAL: 604,
	Settings.Player.YELLOW: 709
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_accessory_score_required(accessory):
	return ACCESSORY_REQUIREMENTS[accessory]

func get_player_score_required(player):
	return PLAYER_REQUIREMENTS[player]

func get_score_possessed(unlock_type):
	if unlock_type == UnlockRequirementType.HIGHSCORE:
		return Save.get_highscore()
	elif unlock_type == UnlockRequirementType.CUMULATIVE:
		return Save.get_cumulative_score()
	else:
		assert(false)

