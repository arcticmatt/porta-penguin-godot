extends Label

func _on_MainMenuLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		SceneTransition.change_scene("res://scenes/MainMenu.tscn", 1, 1)
		MusicPlayer.stop()
		
func reset():
	visible = false
