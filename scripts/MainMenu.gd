extends MarginContainer

var g_player = null

func _input(event):
	# For testing
	if event.is_action_pressed("show_unlocks"):
		_show_unlocks()
		
func _enter_tree():
	$HBoxMain/MarginLeft/VBoxText/Highscore.text = "Highscore: " + str(Save.get_highscore())

func _ready():
	$CharacterPool.g_should_spawn = true
	
	_update_current_player()
		
	g_player.get_node("PlayerSprite/IdleAnimationPlayer").play("Idling", -1, 2)

func _on_Play_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		Settings.disable_trump_mode()
		if SceneTransition.get_saved_main_node():
			SceneTransition.change_scene_node(
				SceneTransition.get_saved_main_node(), 
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

func _on_Unlocks_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		_show_unlocks()

func _show_unlocks():
	$TrumpButtonParent.visible = false
	$Unlocks.enter()
	for node in get_tree().get_nodes_in_group("MainMenuMain"):
		node.visible = false
	for node in get_tree().get_nodes_in_group("MainMenuUnlocks"):
		node.visible = true
	$CharacterPool.hide_all()

func hide_unlocks():
	$TrumpButtonParent.visible = true
	for node in get_tree().get_nodes_in_group("MainMenuMain"):
		node.visible = true
	for node in get_tree().get_nodes_in_group("MainMenuUnlocks"):
		node.visible = false
	$CharacterPool.show_all()
	
	_update_current_player()
		
	g_player.update_texture()
	g_player.update_accessory()
	g_player.get_node("PlayerSprite/IdleAnimationPlayer").play("Idling", -1, 2)

func _update_current_player():
	if Settings.get_player() == Settings.Player.CAT:
		$Penguin.visible = false
		$Cat.visible = true
		g_player = $Cat
	else:
		$Penguin.visible = true
		$Cat.visible = false
		g_player = $Penguin

func is_reset():
	return false
