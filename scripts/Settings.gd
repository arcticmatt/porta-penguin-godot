extends Node

enum Accessory {
	NONE,
	STRAW_HAT,
	NOOGLER,
	BURGER,
	CHEF,
	CROWN,
	MUSHROOM,
	RAINBOW,
	SANTA
}

enum Player {
	DEFAULT,
	BLUE,
	ORANGE,
	PINK,
	PURPLE,
	TEAL,
	YELLOW
}

var g_unlock_node_to_accessory = {
	"StrawHat": Accessory.STRAW_HAT,
	"Noogler": Accessory.NOOGLER,
	"Burger": Accessory.BURGER,
	"Chef": Accessory.CHEF,
	"Crown": Accessory.CROWN,
	"Mushroom": Accessory.MUSHROOM,
	"Rainbow": Accessory.RAINBOW,
	"Santa": Accessory.SANTA
}

var g_unlock_node_to_player = {
	"PenguinBw": Player.DEFAULT,
	"PenguinBlue": Player.BLUE,
	"PenguinOrange": Player.ORANGE,
	"PenguinPink": Player.PINK,
	"PenguinPurple": Player.PURPLE,
	"PenguinTeal": Player.TEAL,
	"PenguinYellow": Player.YELLOW
}

var g_player_to_resource = {
	Player.DEFAULT: "res://assets/sprites/players/Penguin.png",
	Player.BLUE: "res://assets/sprites/players/PenguinBlue.png",
	Player.ORANGE: "res://assets/sprites/players/PenguinOrange.png",
	Player.PINK: "res://assets/sprites/players/PenguinPink.png",
	Player.PURPLE: "res://assets/sprites/players/PenguinPurple.png",
	Player.TEAL: "res://assets/sprites/players/PenguinTeal.png",
	Player.YELLOW: "res://assets/sprites/players/PenguinYellow.png"
}

var g_accessory = Accessory.NONE
var g_player = Player.DEFAULT

func _ready():
	g_player = Save.get_player()
	g_accessory = Save.get_accessory()
	
func set_accessory(accessory):
	g_accessory = accessory
	Save.save_unlocks_accessory(accessory)

func set_player(player):
	g_player = player
	Save.save_unlocks_player(player)

func unlock_node_to_accessory(node_name):
	if not node_name:
		return Accessory.NONE
	return g_unlock_node_to_accessory[node_name]

func unlock_node_to_player(node_name):
	return g_unlock_node_to_player[node_name]
	
func get_accessory():
	return g_accessory

func get_player():
	return g_player

func get_player_resource():
	return g_player_to_resource[g_player]