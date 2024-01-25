extends Area2D

@export var speed = 350

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start(_transform):
	global_transform = _transform
	velocity = transform.x * speed

func _physics_process(delta):
	velocity += acceleration * delta
	# velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta

func _on_Lifetime_timeout():
	queue_free()

func _on_body_entered(body):
	print('hit!')
	
