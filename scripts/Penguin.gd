extends RigidBody2D

const UP_IMPULSE = -55
const INITIAL_BOOST = Vector2(0, -300)
const DEFAULT_POOP_RATE_MS = 750
const LAXATIVE_POOP_RATE_MS = 100

# Powers
const LAXATIVE_POWER = 'laxative'
const NONE_POWER = 'none'

var g_dead = false
var g_poop_pool = []
var g_num_poops = 30
var g_current_poop = 0
var g_poop_res = preload("res://scenes/Poop.tscn")
var g_power_acquire_time_secs = 0
var g_max_power_duration_time_secs = 10
var g_power_acquired = NONE_POWER

var g_min_poop_rate_ms = DEFAULT_POOP_RATE_MS
var g_last_poop_ms = 0

# Signals
signal signal_penguin_dead

func _ready():
	_fill_poop_pool()

func _enter_tree():
	$PenguinSprite/AnimationPlayer.play("Idling", -1, 2)
	
func _input(event):
	if g_dead or get_tree().paused:
		return

	if event is InputEventKey:
		if event.is_action_pressed("ui_select"):
			_penguin_jump()
		elif event.is_action_pressed("ui_down"):
			_penguin_poop()
	if event is InputEventScreenTouch and event.pressed:
		var position = event.position
		if position.x < ProjectSettings.get_setting("display/window/size/width") / 2:
			_penguin_jump()

# So we can hold down to poop
func _process_input():
	if g_dead or get_tree().paused:
		return

	if $ButtonRight.is_pressed():
		_penguin_poop()

func _fill_poop_pool():
	for i in range(g_num_poops):
		var poop_object = g_poop_res.instance()
		g_poop_pool.append(poop_object)
		poop_object.deactivate()
		get_parent().call_deferred("add_child", poop_object)

func _process(delta):
	_process_input()
	if g_power_acquired != NONE_POWER:
		var power_duration = OS.get_system_time_secs() - g_power_acquire_time_secs
		if power_duration >= g_max_power_duration_time_secs:
			_lose_all_powers()
	
func _penguin_jump():
	set_linear_velocity(Vector2(0, 0))
	apply_central_impulse(Vector2(0, UP_IMPULSE))
	$PenguinSprite/AnimationPlayer.stop()
	$PenguinSprite/AnimationPlayer.play("Flap", -1, 1)

func _penguin_poop():
	var time_diff = OS.get_system_time_msecs() - g_last_poop_ms
	if time_diff < g_min_poop_rate_ms:
		return
	g_last_poop_ms = OS.get_system_time_msecs()
	var poop_object = g_poop_pool[g_current_poop]
	g_current_poop = (g_current_poop + 1) % g_num_poops
	poop_object.activate(get_linear_velocity(), position + $PoopPoint.position)

func _on_PenguinRigidBody_body_entered(body):
	emit_signal("signal_penguin_dead", Constants.HIT_SOMETHING)
	
func penguin_game_over():
	$PenguinSprite/AnimationPlayer.stop()
	g_dead = true
	$PenguinSprite.frame = 2
		
func _lose_all_powers():
	print("Lost powers :(")
	g_power_acquired = NONE_POWER
	g_min_poop_rate_ms = DEFAULT_POOP_RATE_MS

func use_power(power_label):
	if power_label == LAXATIVE_POWER:
		g_power_acquire_time_secs = OS.get_system_time_secs()
		g_min_poop_rate_ms = LAXATIVE_POOP_RATE_MS
		g_power_acquired = LAXATIVE_POWER
