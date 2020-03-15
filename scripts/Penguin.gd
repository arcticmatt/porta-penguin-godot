extends RigidBody2D

const UP_IMPULSE = -55
const INITIAL_BOOST = Vector2(0, -300)
const DEFAULT_POOP_RATE_MS = 750
const LAXATIVE_POOP_RATE_MS = 100
const DEFAULT_POOP_SCALE = Vector2(1.5, 1.5)
const CONSTIPATION_POOP_SCALE = Vector2(3, 3)
const RESET_POSITION = Vector2(223, 330)

# Powers
const CONSTIPATION_POWER = 'constipation'
const LAXATIVE_POWER = 'laxative'
const NONE_POWER = 'none'

export var use_poop_button = false
export var disable_input = false
# We do some special casing for the cat
export var is_cat = false

var g_dead = false
var g_poop_pool = []
var g_num_poops = 30
var g_current_poop = 0
var g_poop_res = preload("res://scenes/Poop.tscn")
var g_power_acquire_time_secs = 0
var g_max_power_duration_time_secs = 8
var g_power_acquired = NONE_POWER
var g_poop_scale = DEFAULT_POOP_SCALE

var g_min_poop_rate_ms = DEFAULT_POOP_RATE_MS
var g_last_poop_ms = 0

# Signals
signal signal_player_dead
signal reset_done

var g_reset = false
var g_reset_forces_integrated = false

func _ready():
	_fill_poop_pool()
	
func _enter_tree():
	update_texture()
	update_accessory()
		
	$PlayerSprite/IdleAnimationPlayer.play("Idling", -1, 2)
	
	# No need to reset for intro screen
	if disable_input:
		return
		
	reset()
	# Similarly to when we restart the game, yield until reset is done. 
	# This ensures 
	# a) Player is positioned correctly, and 
	# b) first jump mechanics are consistent
	yield(self, "reset_done")
	get_tree().paused = true

func _exit_tree():
	# Reset when exiting the SceneTree. Avoids a bug when switching playable
	# characters.
	# 1) Start as Penguin.
	# 2) Die.
	# 3) Go to MainMenu.
	# 4) Switch to Cat.
	# 5) Play.
	# 6) _on_PlayerRigidBody_body_entered triggered by Penguin, probably because
	#    there's some amount of time it processes before getting removed from
	#    the SceneTree.
	reset()
	
func reset():
	g_reset = true
	_lose_all_powers()
	$PlayerSprite.frame = 0
	$Collision0.disabled = true
	g_dead = false
	$PlayerSprite/IdleAnimationPlayer.play("Idling", -1, 2)
	g_reset_forces_integrated = false
	
func _integrate_forces(state):
	if g_reset:
		state.set_transform(Transform2D(0.0, RESET_POSITION))
		state.set_angular_velocity(0.0)
		state.set_linear_velocity(Vector2(0, 0))
		g_reset_forces_integrated = true
	
func _input(event):
	if g_dead or get_tree().paused or disable_input or get_parent().is_reset():
		return

	if event is InputEventKey:
		if event.is_action_pressed("ui_select"):
			_player_jump()
		elif event.is_action_pressed("ui_down"):
			_player_poop()
	if event is InputEventScreenTouch and event.pressed:
		var position = event.position
		if position.x < ProjectSettings.get_setting("display/window/size/width") / 2:
			_player_jump()

# So we can hold down to poop
func _process_input():
	if g_dead or get_tree().paused or get_parent().is_reset():
		return

	if use_poop_button and $ButtonRight.is_pressed():
		_player_poop()

func _fill_poop_pool():
	for _i in range(g_num_poops):
		var poop_object = g_poop_res.instance()
		g_poop_pool.append(poop_object)
		poop_object.deactivate()
		get_parent().call_deferred("add_child", poop_object)

func _process(_delta):
	if g_reset and (position - RESET_POSITION).length() < 0.5 and g_reset_forces_integrated:
		emit_signal("reset_done")
		g_reset = false
		$Collision0.disabled = false

	_process_input()
	if g_power_acquired != NONE_POWER:
		var power_duration = OS.get_system_time_secs() - g_power_acquire_time_secs
		if power_duration >= g_max_power_duration_time_secs:
			_lose_all_powers()
	
func _player_jump():
	set_linear_velocity(Vector2(0, 0))
	apply_central_impulse(Vector2(0, UP_IMPULSE))
	$PlayerSprite/FlapAnimationPlayer.stop()
	$PlayerSprite/IdleAnimationPlayer.stop()
	$PlayerSprite/FlapAnimationPlayer.play("Flap", -1, 1)

func _player_poop():
	var time_diff = OS.get_system_time_msecs() - g_last_poop_ms
	if time_diff < g_min_poop_rate_ms:
		return
	g_last_poop_ms = OS.get_system_time_msecs()
	var poop_object = g_poop_pool[g_current_poop]
	g_current_poop = (g_current_poop + 1) % g_num_poops
	poop_object.activate(
		get_linear_velocity(), 
		position + $PoopPoint.position, 
		g_poop_scale)
	$PoopAudioPlayer.play()
	
func _on_PlayerRigidBody_body_entered(_body):
	# Reset happens in _enter_tree() - don't process collisions during the reset
	# process
	if not g_reset:
		emit_signal("signal_player_dead", Constants.HIT_SOMETHING)
	
func player_game_over():
	$PlayerSprite/FlapAnimationPlayer.stop()
	g_dead = true
	$PlayerSprite.frame = 2
		
func _lose_all_powers():
	g_power_acquired = NONE_POWER
	g_min_poop_rate_ms = DEFAULT_POOP_RATE_MS
	g_poop_scale = DEFAULT_POOP_SCALE

func use_power(power_label):
	g_power_acquired = power_label
	g_power_acquire_time_secs = OS.get_system_time_secs()
	if power_label == LAXATIVE_POWER:
		g_min_poop_rate_ms = LAXATIVE_POOP_RATE_MS
	elif power_label == CONSTIPATION_POWER:
		g_poop_scale = CONSTIPATION_POOP_SCALE
	else:
		assert(false)

func update_accessory():
	var accessory = Settings.get_accessory()
	match accessory:
		Settings.Accessory.NONE:
			_hide_all_accessories()
		Settings.Accessory.BURGER:
			_hide_all_accessories()
			$PlayerSprite/Burger.visible = true
		Settings.Accessory.CHEF:
			_hide_all_accessories()
			$PlayerSprite/Chef.visible = true
		Settings.Accessory.CROWN:
			_hide_all_accessories()
			$PlayerSprite/Crown.visible = true
		Settings.Accessory.MUSHROOM:
			_hide_all_accessories()
			$PlayerSprite/Mushroom.visible = true
		Settings.Accessory.RAINBOW:
			_hide_all_accessories()
			$PlayerSprite/Rainbow.visible = true
		Settings.Accessory.SANTA:
			_hide_all_accessories()
			$PlayerSprite/Santa.visible = true
		Settings.Accessory.STRAW_HAT:
			_hide_all_accessories()
			$PlayerSprite/StrawHat.visible = true
		Settings.Accessory.NOOGLER:
			_hide_all_accessories()
			$PlayerSprite/Noogler.visible = true
		_:
			_hide_all_accessories()

func _hide_all_accessories():
	$PlayerSprite/StrawHat.visible = false
	$PlayerSprite/Noogler.visible = false
	$PlayerSprite/Burger.visible = false
	$PlayerSprite/Chef.visible = false
	$PlayerSprite/Crown.visible = false
	$PlayerSprite/Mushroom.visible = false
	$PlayerSprite/Rainbow.visible = false
	$PlayerSprite/Santa.visible = false
		
func update_texture():
	var resource = Settings.get_player_resource()
	# Bug this avoids:
	# 1) Start in MainMenu with Penguin. That means the Cat node will have the 
	#    penguin's texture loaded from the call to update_texture in _ready
	#    (if we don't have the is_cat flag).
	# 2) Change player to Cat.
	# 3) When you hide the unlocks, the player will now be a huge penguin, because
	#    the Cat's texture will still be the penguin texture.
	if resource and not is_cat:
		var texture = Utils.get_texture(resource)
		$PlayerSprite.texture = texture
