extends CanvasLayer
	
func change_scene(path, inspeed = 1.0, outspeed = 1.0):
	MusicPlayer.stop()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(path)
	$AnimationPlayer.play("fadeout", -1, outspeed)
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_after_change(path)
		

func reload_current_scene(inspeed = 1.0, outspeed = 1.0):
	MusicPlayer.stop()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()
	$AnimationPlayer.play("fadeout", -1, outspeed)
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_after_reload(get_tree().get_current_scene().get_name())

func _play_song_after_change(path):
	if path == "res://scenes/Main.tscn":
		MusicPlayer.load_main_song()
		MusicPlayer.play()
	elif path == "res://scenes/MainMenu.tscn":
		MusicPlayer.load_intro_song()
		MusicPlayer.play()

func _play_song_after_reload(name):
	if name == "Main":
		MusicPlayer.load_main_song()
		MusicPlayer.play()
