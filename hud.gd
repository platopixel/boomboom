extends CanvasLayer

signal start_game

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
	emit_signal("start_game")
