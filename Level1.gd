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


func show_score():
	# Define a format string with placeholder '%s'
	var format_string: String = "[center]%s[/center]\n[right]Your score: [color=%s]" + str(points) + "[/color]\nWinning Score: " + str(winning_score) + "[/right]"
	# Using the '%' operator, the placeholder is replaced with the desired value
	var actual_string: String
	if points < winning_score:
		actual_string = format_string % ["[wave amp=50.0 freq=5.0 connected=1]Try Again[/wave]", "red"]
	else:
		actual_string = format_string % ["[rainbow freq=1.0 sat=0.8 val=0.8]You Win![/rainbow]", "green"]

	$LevelScoreLabel.text = actual_string
	$LevelScoreLabel.show()


# Called when the last brick explodes
func level_finished():
	show_score()


func level_over():
	show_score()
	# $RestartLevelButton.show()
	await get_tree().create_timer(2.0).timeout
	call_deferred("queue_free")


func has_won():
	return points == max_score


func level_lost():
	show_score()
	await get_tree().create_timer(1.0).timeout


func _on_restart_level_button_pressed() -> void:
	pass # Replace with function body.
