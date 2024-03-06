extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale = Vector2(randf_range(0.5, 1.5), randf_range(1.0, 5.0))
	self.connect("animation_finished", self._on_AnimatedSprite2D_animation_finished)


func _on_AnimatedSprite2D_animation_finished():
	queue_free()
