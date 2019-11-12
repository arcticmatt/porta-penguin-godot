extends Node

# Save files
const SCORE_FILE = "user://score.save"
const NUM_TIMES_INSTRUCTIONS_SHOWN_FILE = "user://instructions.save"
const UNLOCKS_FILE = "user://unlocks.save"

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
	
func save_unlocks_player(player):
	var save_unlocks = File.new()
	save_unlocks.open(UNLOCKS_FILE, File.WRITE)
	var dict = {
		"player": player
	}
	save_unlocks.store_line(to_json(dict))
	
func get_cumulative_score():
	var first_line = _get_first_line(SCORE_FILE)
	if not first_line:
		return 0
	return int(first_line["cumulative_score"])

func get_highscore():
	var first_line = _get_first_line(SCORE_FILE)
	if not first_line:
		return 0
	return int(first_line["highscore"])
	
func get_num_times_instructions_shown():
	var first_line = _get_first_line(NUM_TIMES_INSTRUCTIONS_SHOWN_FILE)
	if not first_line:
		return 0
	return int(first_line["num_times"])

func get_player():
	var first_line = _get_first_line(UNLOCKS_FILE)
	if not first_line:
		return Settings.Player.DEFAULT
	return int(first_line["player"])

func _get_first_line(filename):
	var file = File.new()
	if not file.file_exists(filename):
		return null
	file.open(filename, File.READ)
	return parse_json(file.get_line())
	
	