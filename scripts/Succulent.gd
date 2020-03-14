extends PhysicsBody2D

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity = 0

var g_started = false

func _ready():
	# Call to add this Node to SceneTree can be deferred - start() may be 
	# called before _ready()
	if not g_started:
		# For performance
		$CollisionPolygon2D.disabled = true

func _process(_delta):
	position.x += g_velocity
	
func reset():
	g_velocity = 0
	# For performance
	$CollisionPolygon2D.disabled = true
	
func start(velocity):
	g_started = true
	g_velocity = -velocity
	$CollisionPolygon2D.disabled = false
	
func update_velocity(velocity):
	g_velocity = -velocity
	
func get_height():
	return $Sprite.texture.get_size().y * $Sprite.scale.y
