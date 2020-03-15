extends Node2D

# Prevent undesirable behavior when spamming
const DISABLE_INPUT_MSECS = 1000
const SHOW_RESTART_DELAY_MSECS = 750

var g_game_over = false
var g_game_over_msecs = null

var g_player = null

var g_character_pool = null

var g_per_round_trump_score = 0

var g_reset = false

# There are two playable characters. 
var g_penguin = null
var g_cat = null

# Needed because we only instance this Node the first time we enter from 
# MainMenu. Every other time, we grab the saved instance and show it. Thus
# _ready() will not be called.
func _enter_tree():
	if not g_penguin:
		g_penguin = $Penguin
	if not g_cat:
		g_cat = $Cat 
		
	if Settings.get_player() == Settings.Player.CAT:
		remove_child(g_penguin)
		g_player = g_cat
		if g_player.get_parent() == null:
			add_child_below_node($PowerPool, g_player)
	else:
		remove_child(g_cat)
		g_player = g_penguin
		if g_player.get_parent() == null:
			add_child_below_node($PowerPool, g_player)
		
	g_player.connect("signal_player_dead", self, "game_over")
		
	g_per_round_trump_score = 0
	
	Levels.reset_current_level()
	if g_character_pool:
		_update_for_current_level()
	
	g_game_over_msecs = null

func _ready():
	# Top
	_add_wall(Vector2(0, -10), Vector2(1600, 10))
	# Bottom, covers grass
	_add_wall(Vector2(0, 900), Vector2(1600, 50))

	if Settings.is_trump_mode_enabled():
		var character_pool_res = load("res://scripts/ObjectPool.gd")
		g_character_pool = character_pool_res.new()
		g_character_pool.init("res://scenes/characters/Trump.tscn", 860, 860, 1700, 12)
		add_child(g_character_pool, true)
	else:
		var character_pool_res = load("res://scripts/ObjectPool.gd")
		g_character_pool = character_pool_res.new()
		g_character_pool.init("res://scenes/characters/", 860, 860, 1700, 2)
		add_child(g_character_pool, true)
		
	_update_for_current_level()

# Do some tear down when this scene exits, because it is saved and re-used
# for subsequent re-entries from MainMenu.
#
# Could also technically do some of this in _enter_tree(), but it's not necessary
# the first time around (the first time the scene is entered via MainMenu),
# so I'm putting it here. 
func _exit_tree():
	$ScoreLabel.reset()
	$ControlsContainer.reset()
	$MainMenuLabel.reset()
	$Pauser.reset()
	
	$Background1.position = Vector2(0, 0)
	$Background2.position = Vector2(1600, 0)
	
	$CenterContainer.visible = false
	
	g_game_over = false
	
	g_character_pool.reset()
	$SucculentPool.reset()
	$PowerPool.reset()
	
	g_per_round_trump_score = 0
	
func _process(_delta):
	if g_game_over_msecs and OS.get_system_time_msecs() - g_game_over_msecs > SHOW_RESTART_DELAY_MSECS:
		$CenterContainer/VBoxContainer/HBoxContainer/RestartLabel.visible = true
		$CenterContainer/VBoxContainer/HBoxContainer/DummyLabel.visible = false
	
func _input(_event):
	if g_game_over_msecs and OS.get_system_time_msecs() - g_game_over_msecs < DISABLE_INPUT_MSECS:
		return
	else:
		$ControlsContainer.visible = false

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
	g_player.player_game_over()
	Save.save_score($ScoreLabel.g_score)
	print('adding %s to trump score' % g_per_round_trump_score)
	Save.add_to_trump_score(g_per_round_trump_score)
	Levels.reset_current_level()
	$MainMenuLabel.visible = true

func score():
	if g_game_over:
		return
	$ScoreLabel.increment_score()
	if Levels.advance_level_if_valid($ScoreLabel.g_score):
		_update_for_current_level()

func _update_for_current_level():
	g_character_pool.use_params(Levels.get_current_character_pool_params())
	$SucculentPool.use_params(Levels.get_current_succulent_pool_params())
	$PowerPool.use_params(Levels.get_current_power_pool_params())

func _on_RestartLabel_gui_input(event):
	if event is InputEventMouseButton and event.pressed and g_game_over:
		_reset()
		
# Custom reset function, to be used instead of SceneTransition.reload_current_scene.
# This is for performance reasons, so we can avoid instancing Nodes, adding them
# to the SceneTree, etc.
func _reset():
	MainMusicPlayer.stop()
	yield(SceneTransition.play_fade_in(1), "completed")
	g_reset = true
	$ScoreLabel.reset()
	$ControlsContainer.reset()
	$MainMenuLabel.reset()
	$Pauser.reset()
	g_player.reset()
	
	$Background1.position = Vector2(0, 0)
	$Background2.position = Vector2(1600, 0)
	
	$CenterContainer.visible = false
	
	# Yield until the Player is done resetting.
	# This ensures 
	# a) Player is positioned correctly, and 
	# b) first jump mechanics are consistent
	yield(g_player, "reset_done")
	get_tree().paused = true
	g_game_over = false
	
	g_character_pool.reset()
	$SucculentPool.reset()
	$PowerPool.reset()
	_update_for_current_level()
	
	g_per_round_trump_score = 0
	
	g_reset = false
	yield(SceneTransition.play_fade_out(1), "completed")
	MainMusicPlayer.play()
		
# Used to keep track of the Trump score per round, so we only have to write to the file at the
# end.
func increment_trump_score():
	g_per_round_trump_score += 1
	
func on_unpause():
	g_character_pool.g_should_spawn = true
	$SucculentPool.g_should_spawn = true
	$PowerPool.g_should_spawn = true
	
func is_reset():
	return g_reset
