extends KinematicBody2D

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	position.x += g_velocity
	
func get_height():
	return $Sprite.texture.get_size().y * $Sprite.scale.y
	
func reset():
	g_velocity = 0
	$Sprite.frame = 0
	
func start():
	g_velocity = -5
