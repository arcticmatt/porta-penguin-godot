extends Label

func _on_MainMenuLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var current = yield(SceneTransition.change_scene_path("res://scenes/MainMenu.tscn", 1, 1, null), "completed")
		SceneTransition.save_main_node(current)
		IntroMusicPlayer.stop()
		MainMusicPlayer.stop()
		
func reset():
	visible = false
