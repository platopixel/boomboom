extends Level

var brick_scene = preload("res://brick.tscn")

@export var NUM_BRICKS = 7
@export var Y_TOP_BUFFER = 200
@export var Y_BOTTOM_BUFFER = 350
@export var X_BUFFER = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_bricks(NUM_BRICKS)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Randomized brick placement
func generate_bricks(num_bricks):
	for i in range(num_bricks):
		var instance = brick_scene.instantiate()
		instance.connect("hit_by_piece", _on_hit_by_piece)
		var random_position = Vector2(
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


func is_overlapping_with_bricks(new_position):
	var bricks = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		if brick.global_position.distance_to(new_position) < brick.get_brick_width():
			return true
	return false


func level_over():
	queue_free()


func has_won():
	return true
