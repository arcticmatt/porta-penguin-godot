extends Sprite

# Velocity at which background moves.
const VELOCITY = -1.5
var texture_width

func _ready():
	texture_width = texture.get_size().x * scale.x

func _process(delta):
	position.x += VELOCITY
	_attempt_reposition()
	
func _attempt_reposition():
	if position.x < -texture_width:
		# Don't just reset position to texture width, otherwise there will be a gap
		position.x += 2 * texture_width
