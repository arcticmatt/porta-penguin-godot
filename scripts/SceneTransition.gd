extends CanvasLayer

var thread = Thread.new()
	
func change_scene(path, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MusicPlayer.stop()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(path)
	
	if long_fade:
		$AnimationPlayer.play("fadeout", -1, outspeed)
	else:
		$AnimationPlayer.play("fadeout2", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_after_change(path)
	
func change_scene_to(scene, path, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MusicPlayer.stop()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(scene)
	
	if long_fade:
		$AnimationPlayer.play("fadeout", -1, outspeed)
	else:
		$AnimationPlayer.play("fadeout2", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_after_change(path)
	
func play_fade_in(speed = 1.0):
	$AnimationPlayer.play("fade", -1, speed)
	yield($AnimationPlayer, "animation_finished")
	
func play_fade_out(speed = 1.0):
	$AnimationPlayer.play("fadeout2", -1, speed)

func reload_current_scene(inspeed = 1.0, outspeed = 1.0):
	MusicPlayer.stop()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()
	$AnimationPlayer.play("fadeout", -1, outspeed)
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_after_reload(get_tree().get_current_scene().get_name())

func _play_progress(speed):
	thread.start(self, "_play_progress_threaded", speed)
	thread.wait_to_finish()

func _play_progress_threaded(speed):
	$WhiteRect.visible = true
	$GreenRect.visible = true
	
	$ProgressBarPlayer.play("progress_smooth", -1, speed)
	yield($ProgressBarPlayer, "animation_finished")
	
	$WhiteRect.visible = false
	$GreenRect.visible = false
	$GreenRect.rect_size = Vector2(0, 62)
	$ProgressBarPlayer.stop()

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
