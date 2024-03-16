extends Level

var brick_scene: PackedScene = preload("res://brick.tscn")

@export var NUM_BRICKS: int = 7
@export var Y_TOP_BUFFER: int = 200
@export var Y_BOTTOM_BUFFER: int = 350
@export var X_BUFFER: int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	generate_bricks(NUM_BRICKS)


# Randomized brick placement
func generate_bricks(num_bricks):
	for i in range(num_bricks):
		var instance: RigidBody2D = brick_scene.instantiate()
		instance.connect("hit_by_piece", _on_hit_by_piece)
		max_score += instance.hit_threshold

		var random_position: Vector2 = Vector2(
			randi_range((X_BUFFER + instance.get_brick_width()), get_viewport_rect().size.x - (X_BUFFER + instance.get_brick_width())),
			randi_range(Y_TOP_BUFFER, get_viewport_rect().size.y - Y_BOTTOM_BUFFER)
		)
		while is_overlapping_with_bricks(random_position):
			# reroll a new position and check again (todo: recursion?)
			random_position = Vector2(
				randi_range((X_BUFFER + instance.get_brick_width()), get_viewport_rect().size.x - (X_BUFFER + instance.get_brick_width())),
				randi_range(Y_TOP_BUFFER, get_viewport_rect().size.y - Y_BOTTOM_BUFFER)
			)
		instance.global_position = random_position
		add_child(instance)

	max_score *= num_bricks


func is_overlapping_with_bricks(new_position):
	var bricks: Array[Node] = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		if brick.global_position.distance_to(new_position) < brick.get_brick_width():
			return true
	return false


func level_over():
	await super()
	call_deferred("queue_free")


func has_won():
	return true
