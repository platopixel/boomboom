extends RigidBody2D

@export var impulse_strength = 500

func _ready():
	self.add_to_group("missile")

func _on_body_entered(body):
	print('body entered')

func fire_missile(direction):
	self.apply_central_impulse(direction * impulse_strength)

func missile_hit():
	pass
