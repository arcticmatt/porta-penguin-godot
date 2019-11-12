extends TextureRect

const TAP_MAX_TIME = 1000
const MAX_POSITION_DIFF = 10

export var g_selected = false
export var g_subfolder = "penguin"

var g_selected_texture = null
var g_unselected_texture = null

var g_press_time = 0
var g_press_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("gui_input", self, "_on_gui_input")

	g_selected = Settings.unlock_node_to_player(self.name) == Settings.get_player()
	
	# Depends on node name!
	var partial_path = "res://assets/sprites/unlocks/" + g_subfolder + "/" + self.name
	var selected_resource = partial_path + "Selected.png"
	var unselected_resource = partial_path + "Unselected.png"
	g_selected_texture = Utils.get_texture(selected_resource)
	g_unselected_texture = Utils.get_texture(unselected_resource)
	
	_update_texture()

# Differentiate between tap and scroll
func _on_gui_input(event):
	if g_selected:
		return

	if event is InputEventMouseButton and event.pressed:
		g_press_time = OS.get_system_time_msecs()
		g_press_position = event.position
	if event is InputEventMouseButton and not event.pressed:
		# First, check to see if the button was held for a long time.
		# Don't allow this. Only allow short taps.
		var time_diff = OS.get_system_time_msecs() - g_press_time
		if time_diff > TAP_MAX_TIME:
			return
		
		# Also don't allow big differences in position
		if (event.position - g_press_position).length() > MAX_POSITION_DIFF:
			return
			
		g_selected = not g_selected
		_update_texture()
		
func _update_texture():
	if g_selected:
		get_parent().unselected_currently_selected()
		self.texture = g_selected_texture
		get_parent().set_selected_node(self)
		Settings.set_player(Settings.unlock_node_to_player(self.name))
	else:
		self.texture = g_unselected_texture		

func get_is_selected():
	return g_selected
	
func unselect():
	g_selected = false
	_update_texture()
