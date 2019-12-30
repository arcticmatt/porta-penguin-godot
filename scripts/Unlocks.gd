extends MarginContainer

const TITLES = [
	"Characters",
	"Accessories",
]
var g_index = 0

func _input(event):
	# For testing
	if event.is_action_pressed("next"):
		$HBoxMain/MarginLeft/VBoxMain/PlayerUnlocks/AnimationPlayer.play("MoveBack")
		$HBoxMain/MarginRight/VBoxMain/AccessoryUnlocks/AnimationPlayer.play("MoveBack")
		g_index += 1
		_update_text()
	elif event.is_action_pressed("previous"):
		$HBoxMain/MarginLeft/VBoxMain/PlayerUnlocks/AnimationPlayer.play("MoveForward")
		$HBoxMain/MarginRight/VBoxMain/AccessoryUnlocks/AnimationPlayer.play("MoveForward")
		g_index -= 1
		_update_text()
	elif event.is_action_pressed("hide_unlocks"):
		get_parent().hide_unlocks()
	
func _ready():
	g_index = 0
	_update_text()
	
func enter():
	g_index = 0
	_update_text()

func _on_Back_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_parent().hide_unlocks()

func _on_Next_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$HBoxMain/MarginLeft/VBoxMain/PlayerUnlocks/AnimationPlayer.play("MoveBack")
		$HBoxMain/MarginRight/VBoxMain/AccessoryUnlocks/AnimationPlayer.play("MoveBack")
		g_index += 1
		_update_text()

func _on_Previous_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$HBoxMain/MarginLeft/VBoxMain/PlayerUnlocks/AnimationPlayer.play("MoveForward")
		$HBoxMain/MarginRight/VBoxMain/AccessoryUnlocks/AnimationPlayer.play("MoveForward")
		g_index -= 1
		_update_text()
		
func _get_subtitle(index):
	var subtitles = [
		"You've pooped on %s people" % Save.get_cumulative_score(),
		"Your highscore is %s" % Save.get_highscore(),
	]
	return subtitles[index]

func _update_text():
	$HBoxMain/MarginLeft/VBoxMain/VBoxText/Subtitle.text = _get_subtitle(g_index)
	$HBoxMain/MarginLeft/VBoxMain/VBoxText/HBoxText/Title.text = TITLES[g_index]
