extends CanvasLayer
	
func change_scene(path):
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(path)
	$AnimationPlayer.play_backwards("fade")

func reload_current_scene(speed = 1.0):
	$AnimationPlayer.play("fade", -1, speed)
	yield($AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()
	$AnimationPlayer.play("fade", -1, -1.0 * speed, true)
	
