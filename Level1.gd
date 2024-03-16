extends Level

@export var next_level_scene: PackedScene = preload("res://levels/level_2.tscn")

var brick1: RigidBody2D
var brick2: RigidBody2D

@export var MAX_SCORE: int = 6
@export var WINNING_SCORE: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	max_score = MAX_SCORE
	winning_score = WINNING_SCORE
	next_level = next_level_scene
	brick1 = $Brick
	brick2 = $Brick2
	brick1.connect("hit_by_piece", _on_hit_by_piece)
	brick2.connect("hit_by_piece", _on_hit_by_piece)
	$LevelScoreLabel.hide()


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
	# show_score()
	pass


func level_over():
	# show_score()
	await super()
	call_deferred("queue_free")


func has_won():
	return points >= WINNING_SCORE


func level_lost():
	# show_score()
	await get_tree().create_timer(1.0).timeout

