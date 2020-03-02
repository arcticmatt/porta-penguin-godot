extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	
func load_intro_song():
	var audio_file = load("res://assets/sounds/KkJiffy.wav")
	self.stream = audio_file
	self.stream.set_loop_mode(1)
	self.stream.set_loop_end(self.stream.get_length() * self.stream.get_mix_rate())
	
func load_main_song():
	var audio_file = load("res://assets/sounds/KkSloop.wav")
	self.stream = audio_file
	self.stream.set_loop_mode(1)
	self.stream.set_loop_end(self.stream.get_length() * self.stream.get_mix_rate())
