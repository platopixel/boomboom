extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_3.tscn")

var brick1: RigidBody2D
var brick2: RigidBody2D
var brick3: RigidBody2D

@export var MAX_SCORE: int = 900 # haven't calculated this yet
@export var WINNING_SCORE: int = 0


func _ready():
	next_level = next_level_scene
	var bricks: Array[Node] = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		brick.connect("hit_by_piece", _on_hit_by_piece)


func level_lost():
	await get_tree().create_timer(1.0).timeout


func level_over():
	queue_free()


func has_won():
	return points >= WINNING_SCORE
