extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if UnlockRequirements.is_trump_mode_unlocked():
		visible = true
	else:
		visible = false

func _on_TrumpButton_pressed():
	Settings.enable_trump_mode()
	if SceneTransition.get_saved_main_node_trump():
		SceneTransition.change_scene_node(SceneTransition.get_saved_main_node_trump(), 1, .5, null)
	else:
		var current = yield(SceneTransition.change_scene_path("res://scenes/Main.tscn", 1, .35, 1.5, true), "completed")
		SceneTransition.save_main_menu_node(current)
