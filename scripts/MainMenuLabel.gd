extends Label

func _on_MainMenuLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("res://scenes/MainMenu.tscn")