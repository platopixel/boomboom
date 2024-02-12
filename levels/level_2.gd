extends Node2D

signal hit_by_piece

@export var next_level: PackedScene = preload("res://levels/level_random.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var brick = $Brick
	$Brick.connect("hit_by_piece", _on_hit_by_piece)
	$Brick2.connect("hit_by_piece", _on_hit_by_piece)


func _on_hit_by_piece(brick):
	emit_signal("hit_by_piece", brick)


func level_over():
	queue_free()