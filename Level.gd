extends Node2D
class_name Level

signal hit_by_piece

var next_level

func has_won():
	print('has_won called on base level class')
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_hit_by_piece(brick):
	emit_signal("hit_by_piece", brick)


func level_over():
	print('level_over called in base Level class')
	pass


func level_lost():
	print('lost_level called in base Level class')
	pass
