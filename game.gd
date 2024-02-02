extends Node2D

var NUM_BRICKS = 15
var NUM_PIECES = 2

var missile_scene = preload("res://missile.tscn")
var brick = preload("res://brick.tscn")
var piece = preload("res://piece.tscn")

var is_playing = false

# This is the main game scene where the gameplay takes place
func _ready():
	$Turret.hide()
	$HUD.show()

func game_start():
	reset_game_state()
	$HUD.hide()
	generate_bricks(NUM_BRICKS)
	$Turret.show()
	is_playing = true

func game_over():
	is_playing = false
	$HUD.show_game_over()
	$HUD.show()

func reset_game_state():
	# clear old pieces and bricks
	var bricks = get_tree().get_nodes_in_group("brick")
	var pieces = get_tree().get_nodes_in_group("piece")
	var missiles = get_tree().get_nodes_in_group("missile")
	for brick in bricks:
		brick.queue_free()
	for piece in pieces:
		piece.queue_free()
	for missile in missiles:
		missile.queue_free()

func _on_brick_hit(position):
	create_pieces(position)
	# this is getting called before the brick removes itself so set this to 1 instead of 0
	if (get_tree().get_nodes_in_group("brick").size() == 1):
		game_over()

func generate_bricks(num_bricks):
	for i in range(num_bricks):
		var instance = brick.instantiate()
		instance.connect("hit", _on_brick_hit)
		var random_position = Vector2(
			randi_range(20, get_viewport_rect().size.x - 20),
			randi_range(100, get_viewport_rect().size.y - 50)
		)
		instance.global_position = random_position
		add_child(instance)

func create_pieces(position):
	for i in range(NUM_PIECES):
		var instance = piece.instantiate()
		# Must use call_deferred here otherwise the instance position will not be set correctly
		instance.call_deferred("set_global_position", position)
		# Apply explosion impulse
		var random_direction = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
		var impulse_strength = 950  # Adjust the strength as needed
		var impulse = random_direction * impulse_strength
		instance.apply_central_impulse(impulse)
		# add scene
		add_child(instance)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_playing:
		# Mouse clicked - instantiate and send scene
		var instance = missile_scene.instantiate()
		add_child(instance)
		instance.global_position = Vector2(get_viewport_rect().size.x / 2, 80)
		send_along_path(instance, event.global_position)

func send_along_path(instance, destination):
	instance.look_at(destination)
	instance.rotation += PI / 2
	# Calculate direction vector from the RigidBody2D to the target position
	var direction = (destination - instance.global_position).normalized()
	instance.fire_missile(direction)


func _on_hud_start_game():
	game_start()
