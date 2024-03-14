extends Node2D
class_name Level

signal hit_by_piece

var base_level_scene: PackedScene = preload("res://levels/base_level.tscn")

var next_level
var points: int = 0
var max_score: int = 0
var winning_score: int = 0
var base_level: Node2D


func has_won():
	print('has_won called on base level class')
	return false


# Called when the node enters the scene tree for the first time.
func _ready():
	base_level = base_level_scene.instantiate()
	add_child(base_level)


func _on_hit_by_piece(brick):
	emit_signal("hit_by_piece", brick)


func level_over():
	var next_level_button: Button  = base_level.get_node("ButtonNextLevel")
	next_level_button.show()
	await next_level_button.pressed


func level_lost():
	# print('lost_level called in base Level class')
	pass

func level_finished():
	# print('level_finished called in base level class')
	pass

func add_points(num_points):
	# print('add_points called in base level class')
	pass
