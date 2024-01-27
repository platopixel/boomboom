extends Node

@export var game_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()

func new_game():
	var game = game_scene.instantiate()
