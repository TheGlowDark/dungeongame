extends Node2D
class_name Room

var s_entered = false

func enter():
	$ColorRect.queue_free()
	s_entered = true
