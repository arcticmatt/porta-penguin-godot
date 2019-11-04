extends Node

# Save files
const SCORE_FILE = "user://score.save"
const NUM_TIMES_INSTRUCTIONS_SHOWN_FILE = "user://instructions.save"

func save_highscore(score):
	var current_highscore = get_highscore()
	if score <= current_highscore:
		return 
	var save_score = File.new()
	save_score.open(SCORE_FILE, File.WRITE)
	save_score.store_line(to_json({"highscore": score}))

func get_highscore():
	var save_score = File.new()
	if not save_score.file_exists(SCORE_FILE):
		return 0
	save_score.open(SCORE_FILE, File.READ)
	var first_line = parse_json(save_score.get_line())
	return int(first_line["highscore"])
	
func save_num_times_instructions_shown(num_times):
	var save_instructions = File.new()
	save_instructions.open(NUM_TIMES_INSTRUCTIONS_SHOWN_FILE, File.WRITE)
	save_instructions.store_line(to_json({"num_times": num_times}))
	
func get_num_times_instructions_shown():
	var save_instructions = File.new()
	if not save_instructions.file_exists(NUM_TIMES_INSTRUCTIONS_SHOWN_FILE):
		return 0
	save_instructions.open(NUM_TIMES_INSTRUCTIONS_SHOWN_FILE, File.READ)
	var first_line = parse_json(save_instructions.get_line())
	return int(first_line["num_times"])
	