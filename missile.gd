extends Area2D

@export var speed = 700

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(_transform):
	global_transform = _transform
	velocity = transform.x * speed

func _physics_process(delta):
	velocity += acceleration * delta
	# velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta

func _on_area_entered(area):
	self.queue_free()
