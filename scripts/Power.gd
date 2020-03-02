extends Area2D

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity = 0
export var g_power_label = ""

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _process(_delta):
	position.x += g_velocity
	
func reset():
	g_velocity = 0
	visible = true
	
func start(velocity):
	g_velocity = -velocity
	
func update_velocity(velocity):
	g_velocity = -velocity
	
func get_height():
	var texture = $AnimatedSprite.frames.get_frame("Sparkle", 0)
	return texture.get_size().y * $AnimatedSprite.scale.y
	
func _on_body_entered(body):
	# Penguin (or Cat, or another player)
	if body.get_collision_layer_bit(1):
		visible = false
		if body.has_method('use_power'):
			body.use_power(g_power_label)
