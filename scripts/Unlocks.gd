extends MarginContainer

func _ready():
	$HBoxMain/MarginLeft/VBoxMain/VBoxText/HowManyPoops.text = "You've pooped on %s people!" % Save.get_cumulative_score()

func _on_Back_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_parent().hide_unlocks()


func _on_Next_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("next pressed!")
		$HBoxMain/MarginLeft/VBoxMain/PlayerUnlocks/AnimationPlayer.play("Move")
		$HBoxMain/MarginRight/VBoxMain/PlayerUnlocks/AnimationPlayer.play("Move")
