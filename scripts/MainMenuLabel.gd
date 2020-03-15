extends Label

func _on_MainMenuLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var current = null;
		if SceneTransition.get_saved_main_menu_node():
			current = yield(SceneTransition.change_scene_node(SceneTransition.get_saved_main_menu_node(), 1, .5, null), "completed")
		else:
			print('WARNING! No saved MainMenu node found when transitioning from Main!')
			current = yield(SceneTransition.change_scene_path("res://scenes/MainMenu.tscn", 1, 1, null), "completed")

		if Settings.is_trump_mode_enabled():
			SceneTransition.save_main_node_trump(current)
		else:
			SceneTransition.save_main_node(current)
		
func reset():
	visible = false
