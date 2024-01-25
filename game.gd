extends Node2D

var NUM_BRICKS = 20

var missile_scene = preload("res://missile.tscn")

# This is the main game scene where the gameplay takes place
func _ready():
	instantiate_turret()
	generate_bricks(NUM_BRICKS)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_bricks(num_bricks):
	var brick = preload("res://brick.tscn")  # Preload your scene
	for i in range(num_bricks):
		var instance = brick.instantiate()
		var random_position = Vector2(
			randi_range(0, get_viewport_rect().size.x),
			randi_range(0, get_viewport_rect().size.y)
		)
		instance.position = random_position
		add_child(instance)

func instantiate_turret():
	var turret = preload("res://turret.tscn")
	var instance = turret.instantiate()
	add_child(instance)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Mouse clicked - instantiate and send scene
		var instance = missile_scene.instantiate()
		add_child(instance)
		instance.position = Vector2(get_viewport_rect().size.x / 2, 50)
		send_along_path(instance, event.global_position)  # End position

func send_along_path(instance, destination):
	# Implement the movement logic here
	# For a simple straight movement:
	instance.look_at(destination)
	instance.rotation += PI / 2
	var tween = create_tween()
	tween.tween_property(instance, "position", destination, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_callback(instance.queue_free)
	# You can connect signals to remove the instance or stop the tween as needed
