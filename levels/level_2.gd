extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_3.tscn")

var brick1: RigidBody2D
var brick2: RigidBody2D
var brick3: RigidBody2D

@export var MAX_SCORE: int = 0
@export var WINNING_SCORE: int = 0


func _ready():
	super()
	# max_score = MAX_SCORE
	winning_score = WINNING_SCORE
	next_level = next_level_scene
	var bricks: Array[Node] = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		brick.connect("hit_by_piece", _on_hit_by_piece)
		max_score += brick.hit_threshold

	max_score *= bricks.size()


func level_lost():
	await get_tree().create_timer(1.0).timeout


func level_over():
	await super()
	call_deferred("queue_free")


func has_won():
	return points >= WINNING_SCORE

