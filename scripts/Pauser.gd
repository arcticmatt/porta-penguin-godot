extends Node2D

var g_disable_input_msecs = 1000
var g_enter_msecs = null

func _enter_tree():
	g_enter_msecs = OS.get_system_time_msecs()

func _input(event):
	if g_enter_msecs and OS.get_system_time_msecs() - g_enter_msecs < g_disable_input_msecs:
		return
	if (event is InputEventMouseButton and event.pressed) or event.is_action_pressed("ui_select"):
		if not get_parent().g_game_over and get_tree().paused:
			get_tree().paused = false
			get_parent().on_unpause()

func reset():
	g_enter_msecs = OS.get_system_time_msecs()
	# Restarting is faster than entering Main for the first time
	g_disable_input_msecs = 400
