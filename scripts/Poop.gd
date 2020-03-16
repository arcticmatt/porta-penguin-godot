extends RigidBody2D

const MIN_STARTING_VELOCITY = Vector2(0, 40)
const OFFSCREEN_POSITION = Vector2(-100, -100)

# Offscreen it, otherwise it's weird
var g_starting_position = OFFSCREEN_POSITION

func _exit_tree():
	deactivate()
	
func _process(delta):
	if global_position.y > 900:
		deactivate()

func deactivate():
	$BottomCollision.disabled = true
	$MiddleCollision.disabled = true
	$TopCollision.disabled = true
	visible = false
	set_linear_velocity(Vector2(0, 0))
	set_gravity_scale(0)
	g_starting_position = OFFSCREEN_POSITION
	
func activate(starting_velocity, new_position, scale):
	# For performance
	$BottomCollision.disabled = false
	$MiddleCollision.disabled = false
	$TopCollision.disabled = false
	set_gravity_scale(10)
	_set_scale(scale)
	g_starting_position = new_position
	visible = true
	if starting_velocity > MIN_STARTING_VELOCITY:
		set_linear_velocity(starting_velocity)
	else:
		set_linear_velocity(MIN_STARTING_VELOCITY)
	apply_central_impulse(Vector2(0, 75))
	
func _integrate_forces(state):
	if g_starting_position:
		state.set_transform(Transform2D(0, g_starting_position))
		state.set_angular_velocity(0.0)
		g_starting_position = null

func _on_Poop_body_entered(body):
	deactivate()
	# Poop hit character, score (if they're a baddy)
	if body.get_collision_layer_bit(2) and not body.g_is_generic:
		# This is kinda jank, whatever
		get_parent().score()
		
func _set_scale(scale):
	$Sprite.set_scale(scale)
	$BottomCollision.set_scale(scale)
	$MiddleCollision.set_scale(scale)
	$TopCollision.set_scale(scale)
