extends RigidBody2D

@export var impulse_strength = 500

func _on_body_entered(body):
	print('body entered')

func fire_missile(direction):
	self.apply_central_impulse(direction * impulse_strength)
