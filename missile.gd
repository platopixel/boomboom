extends RigidBody2D

@export var impulse_strength: int = 1500

signal detonate_missile

func _ready():
	$Sprite2D/AnimationPlayer.connect("animation_finished", _on_flash_animation_finished)
	self.add_to_group("missile")

func _on_AnimatedSprite2D_animation_finished():
	queue_free()

func _on_flash_animation_finished(animation_name):
	# turn off physics detection for the explosion
	self.linear_velocity = Vector2.ZERO
	self.collision_layer = 0
	self.collision_mask = 0
	self.gravity_scale = 0
	$Sprite2D.hide()
	emit_signal("detonate_missile", position)
	queue_free()

func fire_missile(direction):
	self.apply_central_impulse(direction * impulse_strength)

func detonate():
	$Sprite2D/AnimationPlayer.play("flash")
