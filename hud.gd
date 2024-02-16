extends CanvasLayer

signal start_game

func _ready():
	$PointsLabel.hide()
	$NewHighScoreLabel.hide()
	$MultiplierLabel.hide()
	$ResetButton.hide()
	$PrevHighScoreLabel.hide()

func show_message(text):
	$Message.text = text
	$Message.show()

func show_game_over():
	$MultiplierLabel.hide()
	$ResetButton.hide()
	show_message("Game Over")
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(2.0).timeout
	$StartButton.show()


func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	$NewHighScoreLabel.hide()
	$PrevHighScoreLabel.hide()
	$PointsLabel.show()
	$MultiplierLabel.show()
	$ResetButton.show()
	emit_signal("start_game")


func _on_reset_button_pressed():
	emit_signal("start_game")


func update_high_score(points):
	$HighScoreLabel.text = "High Score: " + str(points)


func show_new_high_score(score):
	$NewHighScoreLabel.text = "New High Score! \n" + str(score)
	$NewHighScoreLabel.show()


func show_prev_high_score(score):
	$PrevHighScoreLabel.text = "Previous High Score: " + str(score)
	$PrevHighScoreLabel.show()


func update_points(points):
	$PanelContainer/HBoxContainer/Label.text = "Points: " + str(points)

func update_multiplier(multiplier):
	$PanelContainer/HBoxContainer/Label2.text = str(multiplier) + "x"
