extends Node2D

func _ready():
	$AnimatedSprite.play('default')

func _on_Timer_timeout():
	SceneTransition.change_scene_path(
		"res://scenes/MainMenu.tscn", 
		Constants.FADE_IN_SPLASH, 
		Constants.FADE_OUT_SPLASH,
		null
	)
