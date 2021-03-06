extends Node

# Save files
const SCORE_FILE = "user://score.save"
const NUM_TIMES_INSTRUCTIONS_SHOWN_FILE = "user://instructions.save"
const TRUMP_SCORE_FILE = "user://trump_score.save"
const UNLOCKS_FILE = "user://unlocks.save"

func add_to_trump_score(additional_score):
	var current_trump_score = get_trump_score()
	var file = File.new()
	file.open(TRUMP_SCORE_FILE, File.WRITE)
	var dict = {
		"trump_score": current_trump_score + additional_score
	}
	file.store_line(to_json(dict))

func save_num_times_instructions_shown(num_times):
	var save_instructions = File.new()
	save_instructions.open(NUM_TIMES_INSTRUCTIONS_SHOWN_FILE, File.WRITE)
	save_instructions.store_line(to_json({"num_times": num_times}))

func save_score(score):
	var current_highscore = get_highscore()
	var current_cumulative_score = get_cumulative_score()
	var save_score = File.new()
	save_score.open(SCORE_FILE, File.WRITE)
	var dict = {
		"highscore": max(score, current_highscore),
		"cumulative_score": current_cumulative_score + score
	}
	save_score.store_line(to_json(dict))
	
func save_unlocks_accessory(accessory):
	_save_unlocks_generic("accessory", accessory)
	
func _save_unlocks_generic(key, value):
	# Note: must call this before opening the file
	var unlocks_dict = _get_unlocks()
	if unlocks_dict:
		# Modify existing
		unlocks_dict[key] = value
	else:
		# Make new
		unlocks_dict = {
			key: value
		}
		
	var save_unlocks = File.new()
	save_unlocks.open(UNLOCKS_FILE, File.WRITE)
	save_unlocks.store_line(to_json(unlocks_dict))
	
func save_unlocks_player(player):
	_save_unlocks_generic("player", player)

func get_accessory():
	var first_line = _get_first_line(UNLOCKS_FILE)
	if not first_line or not first_line.has("accessory"):
		return Settings.Accessory.NONE
	return int(first_line["accessory"])
	
func get_cumulative_score():
	var first_line = _get_first_line(SCORE_FILE)
	if not first_line or not first_line.has("cumulative_score"):
		return 0
	return int(first_line["cumulative_score"])

func get_highscore():
	var first_line = _get_first_line(SCORE_FILE)
	if not first_line or not first_line.has("highscore"):
		return 0
	return int(first_line["highscore"])
	
func get_num_times_instructions_shown():
	var first_line = _get_first_line(NUM_TIMES_INSTRUCTIONS_SHOWN_FILE)
	if not first_line or not first_line.has("num_times"):
		return 0
	return int(first_line["num_times"])

func get_player():
	var first_line = _get_first_line(UNLOCKS_FILE)
	if not first_line or not first_line.has("player"):
		return Settings.Player.DEFAULT
	return int(first_line["player"])

func get_trump_score():
	var first_line = _get_first_line(TRUMP_SCORE_FILE)
	if not first_line or not first_line.has("trump_score"):
		return 0
	return int(first_line["trump_score"])

func _get_first_line(filename):
	var file = File.new()
	if not file.file_exists(filename):
		return null
	file.open(filename, File.READ)
	return parse_json(file.get_line())
	
func _get_unlocks():
	var first_line = _get_first_line(UNLOCKS_FILE)
	if not first_line:
		return null
	return first_line
