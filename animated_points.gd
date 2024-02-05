extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rand_x = randf_range(-25, 25)
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(0.1, 0.1), 0.5)
	tween.parallel().tween_property(self, "position", Vector2(self.position.x + rand_x, self.position.y - 40), 0.5)
	tween.tween_callback(self.queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
