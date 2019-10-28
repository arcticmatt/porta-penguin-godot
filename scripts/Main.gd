extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Top
	_add_wall(Vector2(0, -10), Vector2(1600, 10))
	# Bottom, covers grass
	_add_wall(Vector2(0, 900), Vector2(1600, 70))
	pass # Replace with function body.

func _add_wall(position, size):
	var rect = RectangleShape2D.new()
	rect.set_extents(size)
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.position = Vector2(0, 0)
	collision_shape.shape = rect
	
	var collision_object = StaticBody2D.new()
	collision_object.position = position
	collision_object.add_child(collision_shape)
	
	add_child(collision_object)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
