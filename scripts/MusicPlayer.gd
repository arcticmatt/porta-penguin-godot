extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS

	var audio_file = load("res://assets/sounds/MainSong.wav")
	self.stream = audio_file
	self.stream.set_loop_end(self.stream.get_data().size() - 1)
	# 44100 bytes/sec
	self.stream.set_loop_end(4189500)
	self.stream.set_loop_mode(1)