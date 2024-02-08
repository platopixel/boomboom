extends Node2D

var NUM_BRICKS = 12
var NUM_PIECES = 2
var MAX_PIECES = 100 # starts stuttering around 200 or so I think

var missile_scene = preload("res://missile.tscn")
var brick_scene = preload("res://brick.tscn")
var piece_scene = preload("res://piece.tscn")
var explosion_scene = preload("res://explosion.tscn")
var points_scene = preload("res://animated_points.tscn")
var boundary_animation_scene = preload("res://boundary_animation.tscn")

var is_playing = false
var points = 0
var high_score = 0

# This is the main game scene where the gameplay takes place
func _ready():
	$Turret.hide()
	check_high_score() # get high score on game load

func game_start():
	reset_game_state()
	generate_bricks(NUM_BRICKS)
	$Turret.show()
	is_playing = true

func get_high_score_from_config():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("res://boomboom.cfg")
	# If the file didn't load, ignore it.
	if err != OK:
		return high_score
	# Iterate over all sections.
	for config_item in config.get_sections():
		# Fetch the data for each section.
		return config.get_value(config_item, "high_score")

func set_high_score_on_config(new_high_score):
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("res://boomboom.cfg")
	# If the file didn't load, ignore it.
	if err != OK:
		return
	config.set_value("high_score", "high_score", new_high_score)
	config.save("res://boomboom.cfg")

func check_high_score():
	var current_high_score = get_high_score_from_config()
	if points > current_high_score:
		high_score = points
		# save new high score
		set_high_score_on_config(high_score)
	else:
		high_score = current_high_score # set high_score after reading from disk
	# Update label
	$HUD.update_high_score(high_score)


func game_over():
	is_playing = false
	check_high_score()
	$HUD.show_game_over()

func reset_game_state():
	add_points(-(points))
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


func _on_explosion_hit(explosion, body):
	if body.is_in_group("brick"):
		$Camera2D.apply_shake()
		_on_brick_explode(explosion.position, body.num_hits)
		body.queue_free()

func _on_missile_detonate(position):
	# instantiate explosion scene
	var explosion = explosion_scene.instantiate()
	explosion.connect("hit_by_explosion", _on_explosion_hit)
	explosion.position = position
	add_child(explosion)

func _on_brick_explode(position, num_pieces):
	var points = points_scene.instantiate()
	points.value = num_pieces
	points.position = position
	add_child(points)
	add_points(num_pieces)
	
	create_pieces(position, num_pieces)
	# this is getting called before the brick removes itself so set this to 1 instead of 0
	if (get_tree().get_nodes_in_group("brick").size() == 1):
		game_over()

func add_points(num_points):
	points += num_points
	$HUD/PointsLabel.text = "Points: " + str(points)

func _on_brick_hit_by_piece(brick):
	if brick.num_hits >= brick.hit_threshold:
		# explode brick
		_on_explosion_hit(brick, brick) # hack: passing brick as explosion param here
		

func _on_piece_exited_screen(position_x):
	var instance = boundary_animation_scene.instantiate()
	instance.position = Vector2(position_x, get_viewport_rect().size.y)
	add_child(instance)

func is_overlapping_with_bricks(new_position):
	var bricks = get_tree().get_nodes_in_group("brick")
	for brick in bricks:
		if brick.global_position.distance_to(new_position) < 100:
			return true
	return false

func generate_bricks(num_bricks):
	for i in range(num_bricks):
		var instance = brick_scene.instantiate()
		instance.connect("hit_by_piece", _on_brick_hit_by_piece)
		var random_position = Vector2(
			randi_range(20, get_viewport_rect().size.x - 20),
			randi_range(200, get_viewport_rect().size.y - 100)
		)
		if is_overlapping_with_bricks(random_position):
			# reroll a new position and check again (todo: recursion?)
			random_position = Vector2(
				randi_range(20, get_viewport_rect().size.x - 20),
				randi_range(200, get_viewport_rect().size.y - 100)
			)
		instance.global_position = random_position
		add_child(instance)

func create_pieces(position: Vector2, num_pieces: int):
	var count = min(num_pieces, MAX_PIECES)
	for i in range(count):
		var instance = piece_scene.instantiate()
		instance.connect("exited_screen", _on_piece_exited_screen)
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
