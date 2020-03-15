extends CanvasLayer

var thread = Thread.new()

var g_saved_main_node = null

func change_scene_node(node, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MainMusicPlayer.stop_all()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")

	var current_scene = self._remove_current_scene()
	get_tree().get_root().add_child(node)
	
	if long_fade:
		$AnimationPlayer.play("fadeout", -1, outspeed)
	else:
		$AnimationPlayer.play("fadeout2", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_name(node.get_name())
	
	return current_scene
	
func change_scene_path(path, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MainMusicPlayer.stop_all()
	
	$AnimationPlayer.play("fade", -1, inspeed)
	yield($AnimationPlayer, "animation_finished")

	var current_scene = self._remove_current_scene()
	var next_scene_resource = load(path)
	var next_scene = next_scene_resource.instance()
	get_tree().get_root().add_child(next_scene)
	
	if long_fade:
		$AnimationPlayer.play("fadeout", -1, outspeed)
	else:
		$AnimationPlayer.play("fadeout2", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($AnimationPlayer, "animation_finished")
	
	_play_song_path(path)
	
	return current_scene
	
func change_scene_to(scene, path, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MainMusicPlayer.stop_all()
	
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
	
	_play_song_path(path)
	
func play_fade_in(speed = 1.0):
	$AnimationPlayer.play("fade", -1, speed)
	yield($AnimationPlayer, "animation_finished")
	
func play_fade_out(speed = 1.0):
	$AnimationPlayer.play("fadeout2", -1, speed)
	yield($AnimationPlayer, "animation_finished")

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

func _play_song_path(path):
	if path == "res://scenes/Main.tscn":
		MainMusicPlayer.play()
	elif path == "res://scenes/MainMenu.tscn":
		IntroMusicPlayer.play()

func _play_song_name(name):
	if name == "Main":
		MainMusicPlayer.play()

func _get_current_scene():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)
		
func _remove_current_scene():
	var root = get_tree().get_root()
	var current_scene = self._get_current_scene()
	root.remove_child(current_scene)
	return current_scene

func save_main_node(node):
	g_saved_main_node = node

func get_saved_main_node():
	return g_saved_main_node
