extends Node2D

var brick_scene = preload("res://brick.tscn")

signal hit_by_piece

@export var NUM_BRICKS = 12
var next_level = null


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_bricks(NUM_BRICKS)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_brick_hit_by_piece():
	print('brick hit!')
	emit_signal("hit_by_piece", self)


# Randomized brick placement
func generate_bricks(num_bricks):
	for i in range(num_bricks):
		var instance = brick_scene.instantiate()
		instance.connect("hit_by_piece", _on_brick_hit_by_piece)
		var random_position = Vector2(
			randi_range((20 + instance.get_brick_width()), get_viewport_rect().size.x - (20 + instance.get_brick_width())),
			randi_range(200, get_viewport_rect().size.y - 200)
		)
		if is_overlapping_with_bricks(random_position):
			# reroll a new position and check again (todo: recursion?)
			random_position = Vector2(
				randi_range((20 + instance.get_brick_width()), get_viewport_rect().size.x - (20 + instance.get_brick_width())),
				randi_range(200, get_viewport_rect().size.y - 100)
			)
		instance.global_position = random_position
		add_child(instance)


func is_overlapping_with_bricks(new_position):
	var bricks = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		if brick.global_position.distance_to(new_position) < 100:
			return true
	return false


func level_over():
	queue_free()
