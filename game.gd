extends Node2D

var NUM_BRICKS: int = 5
var NUM_PIECES: int = 3
var MAX_PIECES: int = 100 # starts stuttering around 200 or so I think

var missile_scene: PackedScene = preload("res://missile.tscn")
var brick_scene: PackedScene = preload("res://brick.tscn")
var piece_scene: PackedScene = preload("res://piece.tscn")
var explosion_scene: PackedScene = preload("res://explosion.tscn")
var points_scene: PackedScene = preload("res://animated_points.tscn")
var boundary_animation_scene: PackedScene = preload("res://boundary_animation.tscn")
var smoke_animation_scene: PackedScene = preload("res://smoke_animation.tscn")
# Starting level
var level_1_scene: PackedScene = preload("res://levels/level_1.tscn")
# var level_1_scene = preload("res://levels/level_random.tscn")

var is_playing: bool = false
var is_slow_mo: bool = false
var points: int = 0
var high_score: int = 0
var score_multiplier: int = 1

var current_level: Node2D


# This is the main game scene where the gameplay takes place
func _ready():
	$Turret.hide()
	check_high_score() # get high score on game load


func _process(delta):
	if is_slow_mo:
		Engine.time_scale += 0.01
		if Engine.time_scale >= 1.0:
			Engine.time_scale = 1.0
			is_slow_mo = false


func game_start():
	reset_game_state()
	current_level = level_1_scene.instantiate()
	current_level.connect("hit_by_piece", _on_brick_hit_by_piece)
	add_child(current_level)
	$Turret.show()
	is_playing = true
	is_slow_mo = false
	Engine.time_scale = 1.0


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
	var current_high_score: int = get_high_score_from_config()
	if points > current_high_score:
		var prev_high_score: int = current_high_score
		high_score = points
		$HUD.show_new_high_score(high_score)
		$HUD.show_prev_high_score(prev_high_score)
		# save new high score
		set_high_score_on_config(high_score)
	else:
		high_score = current_high_score # set high_score after reading from disk
	# Update label
	$HUD.update_high_score(high_score)


func level_over():
	var missiles: Array[Node] = get_tree().get_nodes_in_group("missile")
	for missile in missiles:
		missile.queue_free()

	var prev_level: Node2D = current_level
	if !current_level.has_won():
		current_level.level_lost()
	elif current_level.next_level:
		current_level = current_level.next_level.instantiate()
		prev_level.level_over()
		current_level.connect("hit_by_piece", _on_brick_hit_by_piece)
		add_child(current_level)
	else:
		game_over()


func game_over():
	is_playing = false
	check_high_score()
	$HUD.show_game_over()


func reset_game_state():
	add_points(-(points))
	points = 0
	if current_level:
		current_level.level_over()
	# clear old pieces and bricks
	var bricks = get_tree().get_nodes_in_group("brick")
	var pieces = get_tree().get_nodes_in_group("piece")
	var missiles = get_tree().get_nodes_in_group("missile")
	var points = get_tree().get_nodes_in_group("points")
	for brick in bricks:
		brick.queue_free()
	for piece in pieces:
		piece.queue_free()
	for missile in missiles:
		missile.queue_free()
	for point in points:
		point.queue_free()


func _on_explosion_hit(body, explosion):
	if body.is_in_group("brick"):
		$Camera2D.apply_shake()
		_on_brick_explode(body, explosion)
		body.queue_free()


func _on_missile_detonate(position):
	# instantiate explosion scene
	var explosion: Area2D = explosion_scene.instantiate()
	explosion.connect("hit_by_explosion", _on_explosion_hit)
	explosion.position = position
	add_child(explosion)


func show_smoke_animation(position):
	var smoke_animation: AnimatedSprite2D = smoke_animation_scene.instantiate()
	smoke_animation.position = position
	add_child(smoke_animation)


func _on_brick_explode(brick, explosion):
	var points: Marker2D = points_scene.instantiate()
	points.value = brick.num_hits
	points.position = brick.position
	add_child(points)
	# show smoke animation
	show_smoke_animation(brick.position)
	start_slow_motion(brick.num_hits)
	create_pieces(brick, explosion)


func add_points(num_points):
	points += num_points
	$HUD.update_points(points)


func _on_brick_hit_by_piece(brick):
	if brick.num_hits >= brick.hit_threshold:
		score_multiplier += 1
		$HUD.update_multiplier(score_multiplier)
		# explode brick
		_on_explosion_hit(brick, null)


func _on_piece_exited_screen(piece):
	add_points(1 * score_multiplier)
	piece.queue_free()
	if (get_tree().get_nodes_in_group("brick").size() == 0) && (get_tree().get_nodes_in_group("piece").size() == 1):
		# game_over()
		call_deferred("level_over")

	var instance = boundary_animation_scene.instantiate()
	instance.position = Vector2(piece.position.x, get_viewport_rect().size.y - 256) # HUD is 256
	add_child(instance)


func start_slow_motion(weight):
	if !is_slow_mo:
		var min_time_scale = 0.1
		var modifier = 1.0 - (weight / 100.0)
		if modifier < min_time_scale:
			modifier = min_time_scale
		Engine.time_scale = modifier
		is_slow_mo = true


func apply_directional_explosion_impulse(piece, explosion):
	var direction: Vector2 = (piece.global_position - explosion.global_position).normalized()
	# Randomize the angle slightly
	var angle_offset: float = randf_range(-10, 10)  # Random angle in degrees
	# Convert angle offset from degrees to radians for Godot's rotation functions
	angle_offset = deg_to_rad(angle_offset)
	# Rotate the direction vector by the random angle offset
	direction = direction.rotated(angle_offset)
	var impulse_strength: int = randi_range(600, 900)
	var impulse: Vector2 = direction * impulse_strength
	piece.apply_central_impulse(impulse)


func apply_random_explosion_impulse(piece):
	var random_direction: Vector2 = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
	var impulse_strength: int = 950
	var impulse = random_direction * impulse_strength
	piece.apply_central_impulse(impulse)


func create_pieces(brick, explosion):
	var count: int = min(brick.num_hits, MAX_PIECES)
	for i in range(count):
		var instance = piece_scene.instantiate()
		var position_offset_x: float = randf_range(-20, 20)  # Random posish offset
		var position_offset_y: float = randf_range(-20, 20)  # Random posish offset
		instance.set_global_position(Vector2(brick.position.x + position_offset_x, brick.position.y + position_offset_y))
		if explosion:
			apply_directional_explosion_impulse(instance, explosion)
		else:
			apply_random_explosion_impulse(instance)
		# add scene
		call_deferred("add_child", instance)


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_playing:
		score_multiplier = 1
		$HUD.update_multiplier(score_multiplier)
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


func _on_bottom_barrier_body_entered(body):
	if body.is_in_group("piece"):
		_on_piece_exited_screen(body)
