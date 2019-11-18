extends GridContainer

var selected_node = null
export var g_unlock_requirement_type = UnlockRequirements.UnlockRequirementType.HIGHSCORE
export var g_unlock_type = UnlockRequirements.UnlockType.PLAYER

func _ready():
	pass # Replace with function body.

func unselect_currently_selected():
	if selected_node and selected_node.has_method("unselect"):
		selected_node.unselect()

func set_selected_node(node):
	if node:
		selected_node = node

func get_unlock_requirement_type():
	return g_unlock_requirement_type

func get_unlock_type():
	return g_unlock_type