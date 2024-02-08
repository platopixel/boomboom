extends Marker2D

var value = 0
@export var animation_time: float = 0.75 # Duration of the floating points animation

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(value)
	var modifier: float = float(value / 100)
	$Label.scale *= modifier
	var rand_x = randf_range(-25, 25)
	var rand_y = randf_range(30, 70)
	var target_modulate = Color(self.modulate.r, self.modulate.g, self.modulate.b, 0.3)
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(0.3, 0.3), animation_time * modifier)
	tween.parallel().tween_property(self, "position", Vector2(self.position.x + rand_x, self.position.y - rand_y), animation_time * modifier)
	tween.parallel().tween_property(self, "modulate", target_modulate, animation_time * modifier)
	tween.tween_callback(self.queue_free)
