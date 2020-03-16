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
		SceneTransition.change_scene_node(
			SceneTransition.get_saved_main_node_trump(), 
			Constants.FADE_IN_CACHED, 
			Constants.FADE_OUT_CACHED, 
			null
		)
	else:
		var current = yield(
			SceneTransition.change_scene_path(
				"res://scenes/Main.tscn", 
				Constants.FADE_IN_WITH_PROGRESS, 
				Constants.FADE_OUT_WITH_PROGRESS, 
				Constants.PROGRESS_BAR, 
				true
			), 
			"completed"
		)
		SceneTransition.save_main_menu_node(current)
