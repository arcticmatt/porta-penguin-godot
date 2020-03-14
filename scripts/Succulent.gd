extends PhysicsBody2D

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity = 0

func _ready():
	# For performance
	$CollisionPolygon2D.disabled = true

func _process(_delta):
	position.x += g_velocity
	if global_position.x < 400:
		$CollisionPolygon2D.disabled = false
	
func reset():
	g_velocity = 0
	# For performance
	$CollisionPolygon2D.disabled = true
	
func start(velocity):
	g_velocity = -velocity
	
func update_velocity(velocity):
	g_velocity = -velocity
	
func get_height():
	return $Sprite.texture.get_size().y * $Sprite.scale.y
