extends Label

const UNLOCKED_TEXT = "unlocked"

# Called when the node enters the scene tree for the first time.
func _ready():
	var unlock_requirement_type = get_parent().get_parent().get_unlock_requirement_type()
	var unlock_type = get_parent().get_parent().get_unlock_type()
	
	assert(UnlockRequirements.UnlockType.values().has(unlock_requirement_type))
	
	var score_required = _get_score_required(unlock_type)
	var score_possessed = UnlockRequirements.get_score_possessed(unlock_requirement_type)
	
	if score_possessed >= score_required:
		self.text = UNLOCKED_TEXT
	else:
		self.text = str(score_required)

func _get_score_required(unlock_type):
	if unlock_type == UnlockRequirements.UnlockType.PLAYER:
		var player_node_name = get_parent().get_child(0).name
		var player_enum = Settings.unlock_node_to_player(player_node_name)
		return UnlockRequirements.get_player_score_required(player_enum)
	elif unlock_type == UnlockRequirements.UnlockType.ACCESSORY:
		var accessory_node_name = get_parent().get_child(0).name
		var accessory_enum = Settings.unlock_node_to_accessory(accessory_node_name)
		return UnlockRequirements.get_accessory_score_required(accessory_enum)