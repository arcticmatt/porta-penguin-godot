extends CanvasLayer

var thread = Thread.new()

# Normal mode
var g_saved_main_node = null

# Trump mode
var g_saved_main_node_trump = null

var g_saved_main_menu_node = null

func change_scene_node(node, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MainMusicPlayer.stop_all()
	
	$FadePlayer.play("fade", -1, inspeed)
	yield($FadePlayer, "animation_finished")

	var current_scene = self._remove_current_scene()
	get_tree().get_root().add_child(node)
	
	# Play song early here, changing with a Node is fast
	_play_song_name(node.get_name())
	
	if long_fade:
		$FadePlayer.play("fadeout_uneven", -1, outspeed)
	else:
		$FadePlayer.play("fadeout", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($FadePlayer, "animation_finished")
	
	return current_scene
	
func change_scene_path(path, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MainMusicPlayer.stop_all()
	
	$FadePlayer.play("fade", -1, inspeed)
	yield($FadePlayer, "animation_finished")
	
	var current_scene = self._remove_current_scene()
	var next_scene_resource = load(path)
	var next_scene = next_scene_resource.instance()
	get_tree().get_root().add_child(next_scene)
	
	if long_fade:
		$FadePlayer.play("fadeout_uneven", -1, outspeed)
	else:
		$FadePlayer.play("fadeout", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($FadePlayer, "animation_finished")
	
	_play_song_path(path)
	
	return current_scene
	
func change_scene_to(scene, path, inspeed = 1.0, outspeed = 1.0, progress_speed = 1.0, long_fade = false):
	MainMusicPlayer.stop_all()
	
	$FadePlayer.play("fade", -1, inspeed)
	yield($FadePlayer, "animation_finished")
	get_tree().change_scene_to(scene)
	
	if long_fade:
		$FadePlayer.play("fadeout_uneven", -1, outspeed)
	else:
		$FadePlayer.play("fadeout", -1, outspeed)
		
	if progress_speed != null:
		_play_progress(progress_speed)
		
	yield($FadePlayer, "animation_finished")
	
	_play_song_path(path)
	
func play_fade_in(speed = 1.0):
	$FadePlayer.play("fade", -1, speed)
	yield($FadePlayer, "animation_finished")
	
func play_fade_out(speed = 1.0):
	$FadePlayer.play("fadeout", -1, speed)
	yield($FadePlayer, "animation_finished")

func _play_progress(speed):
	thread.start(self, "_play_progress_threaded", speed)
	thread.wait_to_finish()

func _play_progress_threaded(speed):
	$WhiteButton.visible = true
	$PinkButton.visible = true
	
	$ProgressBarPlayer.play("progress", -1, speed)
	yield($ProgressBarPlayer, "animation_finished")
	
	$WhiteButton.visible = false
	$PinkButton.visible = false
	$PinkButton.rect_size = Vector2(0, 62)
	$ProgressBarPlayer.stop()

func _play_song_path(path):
	if path == "res://scenes/Main.tscn":
		MainMusicPlayer.play()
	elif path == "res://scenes/MainMenu.tscn":
		IntroMusicPlayer.play()

func _play_song_name(name):
	if name == "Main":
		MainMusicPlayer.play()
	elif name == "MainMenu":
		IntroMusicPlayer.play()

func _get_current_scene():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)
		
func _remove_current_scene():
	var root = get_tree().get_root()
	var current_scene = self._get_current_scene()
	root.remove_child(current_scene)
	return current_scene

func get_saved_main_node():
	return g_saved_main_node
	
func get_saved_main_node_trump():
	return g_saved_main_node_trump

func get_saved_main_menu_node():
	return g_saved_main_menu_node
	
func save_main_node(node):
	g_saved_main_node = node
	
func save_main_node_trump(node):
	g_saved_main_node_trump = node
	
func save_main_menu_node(node):
	g_saved_main_menu_node = node
