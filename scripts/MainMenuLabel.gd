extends Label

func _on_MainMenuLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var current = yield(SceneTransition.change_scene_path("res://scenes/MainMenu.tscn", 1, 1, null), "completed")
		if Settings.is_trump_mode_enabled():
			SceneTransition.save_main_node_trump(current)
		else:
			SceneTransition.save_main_node(current)
		
func reset():
	visible = false
