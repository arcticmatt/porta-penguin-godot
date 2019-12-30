extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS

	var audio_file = load("res://assets/sounds/MainSong.wav")
	self.stream = audio_file 