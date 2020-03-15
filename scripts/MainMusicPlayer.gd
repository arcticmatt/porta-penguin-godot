extends AudioStreamPlayer

func _enter_tree():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	var audio_file = load("res://assets/sounds/KkSloop.ogg")
	self.stream = audio_file
	self.stream.set_loop(true)
	self.stream.set_loop_offset(self.stream.get_length())
	
func stop_all():
	stop()
	IntroMusicPlayer.stop()
