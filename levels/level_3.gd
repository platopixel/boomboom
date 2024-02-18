extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_random.tscn")

var brick1
var brick2

func _ready():
	next_level = next_level_scene
	var bricks = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		brick.connect("hit_by_piece", _on_hit_by_piece)


func level_over():
	queue_free()


func has_won():
	return !brick1 && !brick2
