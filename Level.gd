extends Node2D
class_name Level

signal hit_by_piece

var next_level
var points: int = 0
var max_score: int = 0
var winning_score: int = 0

@onready var score_label = get_node("RichTextLabel")
@onready var winning_score_label = get_node("RichTextLabel2")


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

func level_finished():
	print('level_finished called in base level class')
	pass

func add_points(num_points):
	print('add_points called in base level class')
	pass
