extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale = Vector2(randf_range(0.5, 2.0), randf_range(2.0, 6.0))
	self.connect("animation_finished", self._on_AnimatedSprite2D_animation_finished)


func _on_AnimatedSprite2D_animation_finished():
	queue_free()
