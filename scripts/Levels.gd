extends Node

var level0 = Level.new()
var level1 = Level.new()
var level2 = Level.new()
var level3 = Level.new()
var level4 = Level.new()
var level5 = Level.new()
var level6 = Level.new()
var current_level = 0
var levels = [level0, level1, level2, level3, level4, level5, level6] 
# Score barriers. Let i = current_level. Then, it is an invariant
# that current_score >= score_barriers[i] and current_score < score_barriers[i + 1].
var score_barriers = [0, 5, 10, 20, 40, 60, 80]
#var score_barriers = [0, 1, 2, 3, 4, 5, 6]

func reset_current_level():
	current_level = 0

func _init():
	assert(levels.size() == score_barriers.size())
	
	### Level 0
	# Character pool
	level0.character_pool_params.min_spawn_wait_ms = 1000
	level0.character_pool_params.max_spawn_wait_ms = 2000
	level0.character_pool_params.object_velocity = 5
	# Succulent pool
	level0.succulent_pool_params.disabled = true
	# Power pool
	level0.power_pool_params.disabled = true
	
	### Level 1
	# Character pool
	level1.character_pool_params.min_spawn_wait_ms = 700
	level1.character_pool_params.max_spawn_wait_ms = 1700
	level1.character_pool_params.object_velocity = 6
	# Succulent pool
	level1.succulent_pool_params.min_spawn_wait_ms = 2000
	level1.succulent_pool_params.max_spawn_wait_ms = 4000
	level1.succulent_pool_params.object_velocity = 6
	# Power pool
	level1.power_pool_params.disabled = true
	
	### Level 2
	# Character pool
	level2.character_pool_params.min_spawn_wait_ms = 700
	level2.character_pool_params.max_spawn_wait_ms = 1700
	level2.character_pool_params.object_velocity = 7
	# Succulent pool
	level2.succulent_pool_params.min_spawn_wait_ms = 1000
	level2.succulent_pool_params.max_spawn_wait_ms = 4000
	level2.succulent_pool_params.object_velocity = 7
	# Power pool
	level2.power_pool_params.min_spawn_wait_ms = 5000
	level2.power_pool_params.max_spawn_wait_ms = 9000
	level2.power_pool_params.object_velocity = 7
	
	### Level 3
	# Character pool
	level3.character_pool_params.min_spawn_wait_ms = 500
	level3.character_pool_params.max_spawn_wait_ms = 1500
	level3.character_pool_params.object_velocity = 8
	# Succulent pool
	level3.succulent_pool_params.min_spawn_wait_ms = 1000
	level3.succulent_pool_params.max_spawn_wait_ms = 3000
	level3.succulent_pool_params.object_velocity = 8
	# Power pool
	level3.power_pool_params.min_spawn_wait_ms = 5000
	level3.power_pool_params.max_spawn_wait_ms = 9000
	level3.power_pool_params.object_velocity = 8
	
	### Level 4
	# Character pool
	level4.character_pool_params.min_spawn_wait_ms = 200
	level4.character_pool_params.max_spawn_wait_ms = 1500
	level4.character_pool_params.object_velocity = 9
	# Succulent pool
	level4.succulent_pool_params.min_spawn_wait_ms = 500
	level4.succulent_pool_params.max_spawn_wait_ms = 2500
	level4.succulent_pool_params.object_velocity = 9
	# Power pool
	level4.power_pool_params.min_spawn_wait_ms = 4000
	level4.power_pool_params.max_spawn_wait_ms = 8000
	level4.power_pool_params.object_velocity = 9
	
	### Level 5
	# Character pool
	level5.character_pool_params.min_spawn_wait_ms = 200
	level5.character_pool_params.max_spawn_wait_ms = 1000
	level5.character_pool_params.object_velocity = 10
	# Succulent pool
	level5.succulent_pool_params.min_spawn_wait_ms = 500
	level5.succulent_pool_params.max_spawn_wait_ms = 2000
	level5.succulent_pool_params.object_velocity = 10
	# Power pool
	level5.power_pool_params.min_spawn_wait_ms = 3000
	level5.power_pool_params.max_spawn_wait_ms = 6000
	level5.power_pool_params.object_velocity = 10
	
	### Level 6
	# Character pool
	level6.character_pool_params.min_spawn_wait_ms = 200
	level6.character_pool_params.max_spawn_wait_ms = 1000
	level6.character_pool_params.object_velocity = 10
	# Succulent pool
	level6.succulent_pool_params.min_spawn_wait_ms = 500
	level6.succulent_pool_params.max_spawn_wait_ms = 1200
	level6.succulent_pool_params.object_velocity = 10
	# Power pool
	level6.power_pool_params.min_spawn_wait_ms = 3000
	level6.power_pool_params.max_spawn_wait_ms = 6000
	level6.power_pool_params.object_velocity = 10
	
func get_current_level():
	return levels[current_level]
	
func get_current_character_pool_params():
	return levels[current_level].character_pool_params
	
func get_current_succulent_pool_params():
	print("current level = ", current_level)
	return levels[current_level].succulent_pool_params
	
func get_current_power_pool_params():
	return levels[current_level].power_pool_params
	
func advance_level_if_valid(score):
	if current_level == levels.size() - 1:
		return false
	if score >= score_barriers[current_level + 1]:
		print("advancing level, score = ", score)
		current_level += 1
		return true
	return false
	
func _ready():
	pass # Replace with function body.
	
class ObjectPoolParams:
	var min_spawn_wait_ms = 0
	var max_spawn_wait_ms = 0
	var object_velocity = 0
	var disabled = false

class Level:
	var character_pool_params = ObjectPoolParams.new()
	var succulent_pool_params = ObjectPoolParams.new()
	var power_pool_params = ObjectPoolParams.new()