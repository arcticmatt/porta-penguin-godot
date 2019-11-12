extends Node

enum Player {
	DEFAULT,
	BLUE
}

var g_unlock_node_to_player = {
	"PenguinBw": Player.DEFAULT,
	"PenguinBlue": Player.BLUE
}

var g_player_to_resource = {
	Player.DEFAULT: "res://assets/sprites/players/Penguin.png",
	Player.BLUE: "res://assets/sprites/players/PenguinBlue.png"
}

var g_player = Player.DEFAULT

func _ready():
	g_player = Save.get_player()

func set_player(player):
	g_player = player
	Save.save_unlocks_player(player)

func unlock_node_to_player(node_name):
	return g_unlock_node_to_player[node_name]

func get_player():
	return g_player

func get_player_resource():
	return g_player_to_resource[g_player]