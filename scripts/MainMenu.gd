extends MarginContainer

var g_main_scene = preload("res://scenes/Main.tscn")

func _ready():
	$VBoxContainer/Highscore.text = "Highscore: " + str(Save.get_highscore())

func _on_Play_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to(g_main_scene)
