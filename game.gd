extends Node2D

var NUM_BRICKS = 30
var NUM_PIECES = 5

var missile_scene = preload("res://missile.tscn")
var brick_scene = preload("res://brick.tscn")
var piece_scene = preload("res://piece.tscn")
var explosion_scene = preload("res://explosion.tscn")

var is_playing = false
var points = 0

# This is the main game scene where the gameplay takes place
func _ready():
	$Turret.hide()

func game_start():
	reset_game_state()
	generate_bricks(NUM_BRICKS)
	$Turret.show()
	is_playing = true

func game_over():
	is_playing = false
	$HUD.show_game_over()

func reset_game_state():
	points = 0
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


func _on_explosion_hit(body):
	if body.is_in_group("brick"):
		_on_brick_explode(body.position)
		body.queue_free()

func _on_missile_detonate(position):
	# instantiate explosion scene
	var explosion = explosion_scene.instantiate()
	explosion.connect("hit_by_explosion", _on_explosion_hit)
	explosion.position = position
	add_child(explosion)

func _on_brick_explode(position):
	create_pieces(position)
	# this is getting called before the brick removes itself so set this to 1 instead of 0
	if (get_tree().get_nodes_in_group("brick").size() == 1):
		game_over()

func add_points():
	points += 1
	$HUD/PointsLabel.text = "Points: " + str(points)

func _on_brick_hit(brick):
	add_points()

func generate_bricks(num_bricks):
	for i in range(num_bricks):
		var instance = brick_scene.instantiate()
		instance.connect("hit_by_piece", _on_brick_hit)
		var random_position = Vector2(
			randi_range(20, get_viewport_rect().size.x - 20),
			randi_range(200, get_viewport_rect().size.y - 100)
		)
		instance.global_position = random_position
		add_child(instance)

func create_pieces(position: Vector2):
	for i in range(NUM_PIECES):
		var instance = piece_scene.instantiate()
		# Must use call_deferred here otherwise the instance position will not be set correctly
		instance.call_deferred("set_global_position", position)
		# Apply explosion impulse
		var random_direction = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
		var impulse_strength = 950  # Adjust the strength as needed
		var impulse = random_direction * impulse_strength
		instance.apply_central_impulse(impulse)
		# add scene
		call_deferred("add_child", instance)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_playing:
		# Mouse clicked - instantiate and send scene
		var instance = missile_scene.instantiate()
		instance.connect("detonate_missile", _on_missile_detonate)
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
