extends Area2D

signal hit_by_explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.connect("animation_finished", self._on_AnimatedSprite2D_animation_finished)
	$AnimatedSprite2D.play("explosion")

func _on_AnimatedSprite2D_animation_finished():
	queue_free()

func _on_area_entered(area):
	pass


func _on_body_entered(body):
	emit_signal("hit_by_explosion", body)
