extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_2.tscn")

var brick1: RigidBody2D
var brick2: RigidBody2D

@export var max_score: int = 6
@export var winning_score: int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level = next_level_scene
	brick1 = $Brick
	brick2 = $Brick2
	brick1.connect("hit_by_piece", _on_hit_by_piece)
	brick2.connect("hit_by_piece", _on_hit_by_piece)
	$LevelScoreLabel.hide()
	$RestartLevelButton.hide()


# Called when the last brick explodes
func level_finished():
	$LevelScoreLabel.text = "Your score: " + str(points) + "\nWinning Score: " + str(winning_score) + "\nMax Score: " + str(max_score)
	$LevelScoreLabel.show()


func level_over():
	$LevelScoreLabel.show()
	$RestartLevelButton.show()
	await get_tree().create_timer(1.0).timeout
	call_deferred("queue_free")


func has_won():
	return points == max_score


func level_lost():
	$LevelScoreLabel.text = "Your score: " + str(points) + "\nWinning Score: " + str(winning_score) + "\nMax Score: " + str(max_score)
	$LevelScoreLabel.show()
	await get_tree().create_timer(3.0).timeout


func _on_restart_level_button_pressed() -> void:
	pass # Replace with function body.
