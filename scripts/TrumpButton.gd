extends TextureButton

var g_main_scene = preload("res://scenes/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_TrumpButton_pressed():
	Settings.enable_trump_mode()
	MusicPlayer.play()
	get_tree().change_scene_to(g_main_scene)
