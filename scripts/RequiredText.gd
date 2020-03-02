extends Label

const UNLOCKED_TEXT = "unlocked"

# Called when the node enters the scene tree for the first time.
func _ready():
	var unlock_requirement_type = get_parent().get_parent().get_unlock_requirement_type()
	
	assert(UnlockRequirements.UnlockType.values().has(unlock_requirement_type))
	
	var score_required = _get_score_required()
	var score_possessed = UnlockRequirements.get_score_possessed(unlock_requirement_type)
	
	if score_possessed >= score_required:
		self.text = UNLOCKED_TEXT
	else:
		self.text = str(score_required)

func _get_score_required():
	var node_name = get_parent().get_child(0).name
	var enum_val = Settings.unlock_node_to_unlockable(node_name)
	return UnlockRequirements.get_score_required(enum_val)
