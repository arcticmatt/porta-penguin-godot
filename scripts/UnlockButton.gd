extends TextureRect

const TAP_MAX_TIME = 1000
const MAX_POSITION_DIFF = 10

# Subfolders
const PENGUIN_SUBFOLDER = "penguin"
const ACCESSORIES_SUBFOLDER = "accessories"

export var g_selected = false
export var g_subfolder = PENGUIN_SUBFOLDER

var g_selected_texture = null
var g_unselected_texture = null
var g_locked_texture = null

var g_press_time = 0
var g_press_position = null

var g_which_unlock = null

var g_unlock_grid = null

# Called when the node enters the scene tree for the first time.
func _ready():
	g_unlock_grid = get_parent().get_parent()
	self.connect("gui_input", self, "_on_gui_input")
	
	g_which_unlock = WhichUnlock.new(g_subfolder)
	g_selected = g_which_unlock.get_selected(self.name)
	
	# Depends on node name!
	var partial_path = "res://assets/sprites/unlocks/" + g_subfolder + "/" + self.name
	var selected_resource = partial_path + "Selected.png"
	var unselected_resource = partial_path + "Unselected.png"
	var locked_resource = null
	# Hardcoding, hacky
	if g_subfolder == PENGUIN_SUBFOLDER:
		locked_resource = "res://assets/sprites/unlocks/penguin/PenguinLocked.png"
	else:
		locked_resource = partial_path + "Locked.png"
	g_selected_texture = Utils.get_texture(selected_resource)
	g_unselected_texture = Utils.get_texture(unselected_resource)
	g_locked_texture = Utils.get_texture(locked_resource)
	
	_init_texture()

# Differentiate between tap and scroll
func _on_gui_input(event):
	if (g_selected and g_subfolder == PENGUIN_SUBFOLDER) or self.texture == g_locked_texture:
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
		
func _init_texture():
	var score_required = g_which_unlock.get_score_required(self.name)
	var score_possessed = UnlockRequirements.get_score_possessed(g_unlock_grid.get_unlock_requirement_type())
	
	if score_possessed < score_required:
		print("using locked texture")
		self.texture = g_locked_texture
		return
	
	if g_selected:
		self.texture = g_selected_texture
		g_unlock_grid.set_selected_node(self)
	else:
		self.texture = g_unselected_texture
		
func _update_texture():
	if g_selected:
		g_unlock_grid.unselect_currently_selected()
		self.texture = g_selected_texture
		g_unlock_grid.set_selected_node(self)
		g_which_unlock.update_settings(self.name)
	else:
		self.texture = g_unselected_texture
		g_unlock_grid.set_selected_node(null)
		g_which_unlock.update_settings(null)

func get_is_selected():
	return g_selected
	
func unselect():
	g_selected = false
	_update_texture()
	
# Contains unlock specific logic (e.g. logic that changes depending on whether 
# we're talking about play unlocks or accessory unlocks, etc.)
class WhichUnlock:
	var g_subfolder = null
	func _init(subfolder):
		g_subfolder = subfolder
	
	func get_score_required(name):
		if g_subfolder == PENGUIN_SUBFOLDER:
			var player_enum = Settings.unlock_node_to_player(name)
			return UnlockRequirements.get_player_score_required(player_enum)
		elif g_subfolder == ACCESSORIES_SUBFOLDER:
			var accessory_enum = Settings.unlock_node_to_accessory(name)
			return UnlockRequirements.get_accessory_score_required(accessory_enum)
		
	func get_selected(name):
		if g_subfolder == PENGUIN_SUBFOLDER:
			return Settings.unlock_node_to_player(name) == Settings.get_player()
		elif g_subfolder == ACCESSORIES_SUBFOLDER:
			return Settings.unlock_node_to_accessory(name) == Settings.get_accessory()
			
	func update_settings(name):
		if name and g_subfolder == PENGUIN_SUBFOLDER:
			Settings.set_player(Settings.unlock_node_to_player(name))
		elif g_subfolder == ACCESSORIES_SUBFOLDER:
			return Settings.set_accessory(Settings.unlock_node_to_accessory(name))