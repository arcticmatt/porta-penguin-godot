extends Node2D

var g_main_menu_scene = preload("res://scenes/MainMenu.tscn")

func _ready():
	$AnimatedSprite.play('default')

func _on_Timer_timeout():
	SceneTransition.change_scene_to(
		g_main_menu_scene, 
		"res://scenes/MainMenu.tscn", 
		1, 
		1
	)
