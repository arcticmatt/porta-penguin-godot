extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	
func load_intro_song():
	var audio_file = load("res://assets/sounds/NewIntro.wav")
	self.stream = audio_file
	self.stream.set_loop_end(self.stream.get_data().size() - 1)
	# 44100 bytes/sec. TODO change this
	self.stream.set_loop_end(4189500)
	self.stream.set_loop_mode(1)

func load_main_song():
	var audio_file = load("res://assets/sounds/NewMain.wav")
	self.stream = audio_file
	self.stream.set_loop_end(self.stream.get_data().size() - 1)
	# 44100 bytes/sec. TODO change this
	self.stream.set_loop_end(4189500)
	self.stream.set_loop_mode(1)
	
