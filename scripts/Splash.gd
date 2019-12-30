extends Node2D

var g_main_menu_scene = preload("res://scenes/MainMenu.tscn")

func _ready():
	print("what")

func _on_Timer_timeout():
	print("what")
	get_tree().change_scene_to(g_main_menu_scene)
