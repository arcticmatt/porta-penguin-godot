extends PhysicsBody2D

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity = 0

func _process(_delta):
	position.x += g_velocity
	
func reset():
	g_velocity = 0
	
func start(velocity):
	g_velocity = -velocity
	
func update_velocity(velocity):
	g_velocity = -velocity
	
func get_height():
	return $Sprite.texture.get_size().y * $Sprite.scale.y
