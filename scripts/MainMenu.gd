extends MarginContainer

var g_main_scene = preload("res://scenes/Main.tscn")

func _ready():
	$VBoxContainer/Highscore.text = "Highscore: " + str(Save.get_highscore())
	$Penguin/PenguinSprite/AnimationPlayer.play("Idling", -1, 2)

func _on_Play_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to(g_main_scene)

func _on_Unlocks_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		_show_unlocks()
			
func _show_unlocks():
	for node in get_tree().get_nodes_in_group("MainMenuMain"):
		node.visible = false
	for node in get_tree().get_nodes_in_group("MainMenuUnlocks"):
		node.visible = true
	$CharacterPool.hide_all()

func hide_unlocks():
	$Penguin.update_texture()
	$Penguin/PenguinSprite/AnimationPlayer.play("Idling", -1, 2)
	for node in get_tree().get_nodes_in_group("MainMenuMain"):
		node.visible = true
	for node in get_tree().get_nodes_in_group("MainMenuUnlocks"):
		node.visible = false
	$CharacterPool.show_all()
