extends Marker2D

var value = 0
@export var animation_time: float = 1.0 # Duration of the floating points animation
@export var MIN_SCALE: Vector2 = Vector2(.75, .75)
@export var MAX_SCALE: Vector2 = Vector2(3, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(value)
	var modifier: float = float(value / 15.0)
	var modified_scale = $Label.scale * modifier / 10
	if modified_scale >= MAX_SCALE:
		modified_scale = MAX_SCALE
	elif modified_scale < MIN_SCALE:
		modified_scale = MIN_SCALE
	$Label.scale = modified_scale
	var rand_x = randf_range(-5, 5)
	var rand_y = randf_range(60, 70)
	var target_modulate = Color(self.modulate.r * modifier, self.modulate.g, self.modulate.b, 0.0)
	# var modified_timer = animation_time * modifier
	var modified_timer = animation_time
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(0.3, 0.3), modified_timer)
	tween.parallel().tween_property(self, "position", Vector2(self.position.x + rand_x, self.position.y - rand_y), modified_timer)
	tween.parallel().tween_property(self, "modulate", target_modulate, modified_timer * 0.75)
	tween.tween_callback(self.queue_free)
