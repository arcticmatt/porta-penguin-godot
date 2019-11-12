extends GridContainer

var selected_node = null

func _ready():
	pass # Replace with function body.

func unselected_currently_selected():
	if selected_node and selected_node.has_method("unselect"):
		selected_node.unselect()

func set_selected_node(node):
	selected_node = node