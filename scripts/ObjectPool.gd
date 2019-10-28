extends Node2D

const LEFT_BOUND = -50
export var g_path = ""
# y measured from bottom of sprites, so characters all line up
export var g_min_y = 860
export var g_max_y = 860
export var g_starting_x = 1700
export var g_copies_of_each = 3

var g_min_spawn_wait_ms = 500
var g_max_spawn_wait_ms = 1500
var g_rand_spawn_wait_ms = 0
var g_last_spawn_time_ms = 0
var g_object_pool = []
var g_object_pool_available = []
var g_max_available_objects = null

func _ready():
	var files = _list_files_in_directory(g_path)
	print(files)
	for file in files:
		var full_path = g_path + file
		
		for i in range(g_copies_of_each):
			var object = load(full_path).instance()
			object.global_position = _get_random_global_position(object)
			g_object_pool.append(object)
			g_object_pool_available.append(object)
			get_parent().call_deferred('add_child', object)
	
	g_max_available_objects = g_object_pool.size()
	
func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

func _process(delta):
	var time_diff = OS.get_system_time_msecs() - g_last_spawn_time_ms
	if time_diff > g_rand_spawn_wait_ms:
		var available_object = _find_and_remove_available_object()
		if available_object:
			available_object.global_position = _get_random_global_position(available_object)
			available_object.start()
			g_last_spawn_time_ms = OS.get_system_time_msecs()
			g_rand_spawn_wait_ms = rand_range(g_min_spawn_wait_ms, g_max_spawn_wait_ms)
	_add_to_available_objects()
	
func _add_to_available_objects():
	for object in g_object_pool:
		if object.global_position.x < LEFT_BOUND:
			object.global_position = _get_random_global_position(object)
			object.reset()
			g_object_pool_available.append(object)
			
	assert(g_object_pool_available.size() <= g_max_available_objects)
		
func _find_and_remove_available_object():
	if g_object_pool_available.size() == 0:
		return null
	var available_index = randi() % g_object_pool_available.size()
	var available_object = g_object_pool_available[available_index]
	g_object_pool_available.remove(available_index)
	return available_object
	
func _get_random_global_position(object):
	var texture_height = object.get_height()
	var starting_y = rand_range(g_min_y, g_max_y) - (texture_height / 2)
	return Vector2(g_starting_x, starting_y)