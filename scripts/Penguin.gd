extends RigidBody2D

const UP_IMPULSE = -55
var g_dead = false

func _ready():
	pass
	
func _input(event):
	if g_dead:
		return
	if event is InputEventKey and event.is_action_pressed("ui_select"):
		_penguin_jump()

func _process(delta):
	pass
	
func _penguin_jump():
	set_linear_velocity(Vector2(0, 0))
	apply_central_impulse(Vector2(0, UP_IMPULSE))
	$PenguinSprite/AnimationPlayer.stop()
	$PenguinSprite/AnimationPlayer.play("Flap")


func _on_PenguinRigidBody_body_entered(body):
	$PenguinSprite/AnimationPlayer.stop()
	g_dead = true
	$PenguinSprite.frame = 2
