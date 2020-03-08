extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	
func load_intro_song():
	var audio_file = load("res://assets/sounds/KkJiffy.ogg")
	self.stream = audio_file
	self.stream.set_loop(true)
	self.stream.set_loop_offset(self.stream.get_length())
	
func load_main_song():
	var audio_file = load("res://assets/sounds/KkSloop.ogg")
	self.stream = audio_file
	self.stream.set_loop(true)
	self.stream.set_loop_offset(self.stream.get_length())
