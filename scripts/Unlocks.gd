extends MarginContainer

func _ready():
	$VBoxContainer/VBoxContainerText/HowManyPoops.text = "You've pooped on %s people!" % Save.get_cumulative_score()

func _on_Back_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_parent().hide_unlocks()
