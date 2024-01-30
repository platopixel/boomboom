extends Area2D

@export var speed = 700
@export var INITIAL_SPEED = 100

var velocity = INITIAL_SPEED
var acceleration = Vector2.ZERO

func _on_area_entered(area):
	self.queue_free()
