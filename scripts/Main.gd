extends Node2D

# Prevent undesirable behavior when spamming
const DISABLE_INPUT_MSECS = 1000
const SHOW_RESTART_DELAY_MSECS = 750

var g_game_over = false
var g_game_over_msecs = null

var g_player = null

func _ready():
	if Settings.get_player() == Settings.Player.CAT:
		remove_child($Penguin)
		g_player = $Cat
	else:
		remove_child($Cat)
		g_player = $Penguin

	# Top
	_add_wall(Vector2(0, -10), Vector2(1600, 10))
	# Bottom, covers grass
	_add_wall(Vector2(0, 900), Vector2(1600, 70))
	g_player.connect("signal_penguin_dead", self, "game_over")
	get_tree().paused = true
	g_game_over_msecs = null
	_update_for_current_level()
	
func _process(delta):
	if g_game_over_msecs and OS.get_system_time_msecs() - g_game_over_msecs > SHOW_RESTART_DELAY_MSECS:
		$CenterContainer/VBoxContainer/HBoxContainer/RestartLabel.visible = true
		$CenterContainer/VBoxContainer/HBoxContainer/DummyLabel.visible = false
	
func _input(event):
	if g_game_over_msecs and OS.get_system_time_msecs() - g_game_over_msecs < DISABLE_INPUT_MSECS:
		return
	else:
		$ControlsContainer.visible = false
		
	# For video recording
	if $CenterContainer/VBoxContainer/HBoxContainer/RestartLabel.visible and event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _add_wall(position, size):
	var rect = RectangleShape2D.new()
	rect.set_extents(size)
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.position = Vector2(0, 0)
	collision_shape.shape = rect
	
	var collision_object = StaticBody2D.new()
	collision_object.position = position
	collision_object.add_child(collision_shape)
	collision_object.collision_layer = 0
	collision_object.set_collision_layer_bit(0, true)
	collision_object.collision_mask = 0
	
	add_child(collision_object)
	
func game_over(game_over_text):
	if g_game_over:
		return
	g_game_over_msecs = OS.get_system_time_msecs()
	$CenterContainer.visible = true
	if UnlockRequirements.is_new_accessory_unlocked($ScoreLabel.g_score):
		$CenterContainer/VBoxContainer/DeathLabel.text = Constants.NEW_ACCESSORY
	elif UnlockRequirements.is_new_character_unlocked($ScoreLabel.g_score):
		$CenterContainer/VBoxContainer/DeathLabel.text = Constants.NEW_CHARACTER
	else:
		$CenterContainer/VBoxContainer/DeathLabel.text = game_over_text
	g_game_over = true
	g_player.penguin_game_over()
	Save.save_score($ScoreLabel.g_score)
	Levels.reset_current_level()
	$MainMenuLabel.visible = true

func score():
	if g_game_over:
		return
	$ScoreLabel.increment_score()
	if Levels.advance_level_if_valid($ScoreLabel.g_score):
		_update_for_current_level()

func _update_for_current_level():
	$CharacterPool.use_params(Levels.get_current_character_pool_params())
	$SucculentPool.use_params(Levels.get_current_succulent_pool_params())
	$PowerPool.use_params(Levels.get_current_power_pool_params())

func _on_RestartLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed and g_game_over:
		get_tree().reload_current_scene()
