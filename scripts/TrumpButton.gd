extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if UnlockRequirements.is_trump_mode_unlocked():
		visible = true
	else:
		visible = false

func _on_TrumpButton_pressed():
	Settings.enable_trump_mode()
	if SceneTransition.get_saved_main_node():
		SceneTransition.change_scene_node(SceneTransition.get_saved_main_node(), 1, 1, null)
	else:
		SceneTransition.change_scene_path("res://scenes/Main.tscn", 1, .35, 1.5, true)
