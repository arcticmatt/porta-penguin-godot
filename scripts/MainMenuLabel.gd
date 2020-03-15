extends Label

func _on_MainMenuLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var current = yield(SceneTransition.change_scene_path("res://scenes/MainMenu.tscn", 1, 1, null), "completed")
		SceneTransition.save_main_node(current)
		MainMusicPlayer.stop_all()
		
func reset():
	visible = false
