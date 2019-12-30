extends HBoxContainer

const MAX_TIMES_INSTRUCTIONS_SHOWN = 5

export var g_always_show_instructions = false

func _ready():
	var num_times_instructions_shown = Save.get_num_times_instructions_shown()
	if num_times_instructions_shown < MAX_TIMES_INSTRUCTIONS_SHOWN:
		Save.save_num_times_instructions_shown(num_times_instructions_shown + 1)
	elif not g_always_show_instructions:
		visible = false