extends PhysicsBody2D

export var g_is_generic = false
var g_is_trump = false

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity = 0

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	# Programatically set to make sure we're being consistent
	collision_layer = 4
	collision_mask = 8
	$Collision0.disabled = true
	
	# A little jank, but it works
	if "Trump" in name:
		g_is_trump = true

func _process(delta):
	position.x += g_velocity
	
func get_height():
	return $Sprite.texture.get_size().y * scale.y * $Sprite.scale.y
	
func reset():
	g_velocity = 0
	$Sprite.frame = 0
	$Collision0.disabled = true
	
func start(velocity):
	g_velocity = -velocity
	$Collision0.disabled = false
	$Sprite/AnimationPlayer.play("Walk")
	
func update_velocity(velocity):
	g_velocity = -velocity
	
func _on_body_entered(body):
	# Pooped on
	if body.get_collision_layer_bit(3):
		get_parent().get_node("SquishAudioPlayer").play()
		$Sprite/AnimationPlayer.stop()
		$Sprite.frame = 2
		# If a "generic" character is pooped on, it's game over!
		if g_is_generic:
			get_parent().game_over(Constants.POOP_ON_GENERIC)
		elif g_is_trump:
			get_parent().increment_trump_score()
