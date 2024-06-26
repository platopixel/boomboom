extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_random.tscn")

@onready var brick1: RigidBody2D
@onready var brick2: RigidBody2D

func _ready():
	super()
	next_level = next_level_scene
	var bricks: Array[Node] = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		brick.connect("hit_by_piece", _on_hit_by_piece)
		max_score += brick.hit_threshold

	max_score *= bricks.size()


func level_over():
	await super()
	call_deferred("queue_free")


func has_won():
	return !brick1 && !brick2
