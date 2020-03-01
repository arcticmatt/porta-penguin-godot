extends Node

#
# Contains requirements needed to unlock players, accesories, etc.
#

const TRUMP_SCORE_REQUIRED = 50

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
	Settings.Accessory.NOOGLER: 30,
	Settings.Accessory.BURGER: 50,
	Settings.Accessory.CHEF: 70,
	Settings.Accessory.CROWN: 90,
	Settings.Accessory.MUSHROOM: 110,
	Settings.Accessory.RAINBOW: 130,
	Settings.Accessory.SANTA: 150
}

const PLAYER_REQUIREMENTS = {
	Settings.Player.DEFAULT: 0,
	Settings.Player.BLUE: 50,
	Settings.Player.ORANGE: 100,
	Settings.Player.PINK: 150,
	Settings.Player.PURPLE: 200,
	Settings.Player.TEAL: 250,
	Settings.Player.YELLOW: 300,
	Settings.Player.CAT: 700
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_score_required(unlockable):
	if ACCESSORY_REQUIREMENTS.has(unlockable):
		return ACCESSORY_REQUIREMENTS[unlockable]
	elif PLAYER_REQUIREMENTS.has(unlockable):
		return PLAYER_REQUIREMENTS[unlockable]
	else:
		assert(false)

func get_score_possessed(unlock_type):
	if unlock_type == UnlockRequirementType.HIGHSCORE:
		return Save.get_highscore()
	elif unlock_type == UnlockRequirementType.CUMULATIVE:
		return Save.get_cumulative_score()
	else:
		assert(false)

func is_new_accessory_unlocked(new_highscore):
	var current_highscore = Save.get_highscore()
	var last_key = ACCESSORY_REQUIREMENTS.keys()[ACCESSORY_REQUIREMENTS.size() - 1]
	var current_key = last_key
	
	for key in ACCESSORY_REQUIREMENTS:
		if ACCESSORY_REQUIREMENTS[key] > current_highscore:
			current_key = key - 1
			break
		
	if current_key == last_key:
		return false
	
	return new_highscore >= ACCESSORY_REQUIREMENTS[current_key + 1]
	
func is_new_character_unlocked(additional_score):
	var current_cumulative_score = Save.get_cumulative_score()
	var last_key = PLAYER_REQUIREMENTS.keys()[PLAYER_REQUIREMENTS.size() - 1]
	var current_key = last_key
	
	for key in PLAYER_REQUIREMENTS:
		if PLAYER_REQUIREMENTS[key] > current_cumulative_score:
			current_key = key - 1
			break
		
	if current_key == last_key:
		return false
	
	return current_cumulative_score + additional_score >= PLAYER_REQUIREMENTS[current_key + 1]
	
func is_trump_mode_unlocked():
	return Save.get_trump_score() >= TRUMP_SCORE_REQUIRED
