extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_2.tscn")

var brick1
var brick2

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level = next_level_scene
	brick1 = $Brick
	brick2 = $Brick2
	brick1.connect("hit_by_piece", _on_hit_by_piece)
	brick2.connect("hit_by_piece", _on_hit_by_piece)


func level_over():
	call_deferred("queue_free")


func has_won():
	return !brick1 && !brick2


func level_lost():
	print('level lost')
