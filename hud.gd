extends CanvasLayer

signal start_game

func _ready():
	$PointsLabel.hide()

func show_message(text):
	$Message.text = text
	$Message.show()

func show_game_over():
	show_message("Game Over")
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(2.0).timeout
	$StartButton.show()

func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	$PointsLabel.show()
	emit_signal("start_game")


func _on_reset_button_pressed():
	emit_signal("start_game")


func update_high_score(points):
	$HighScoreLabel.text = "High Score: " + str(points)
