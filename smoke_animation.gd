extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("smoke_animation")
	self.connect("animation_finished", _on_animation_finished)
	self.play("smoke_1")


func _on_animation_finished():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
