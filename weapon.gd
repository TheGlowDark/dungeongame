extends Node2D

var rotation_speed = 10

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - $".".global_position).normalized()
	var target_angle = direction.angle()
	
	rotation = lerp_angle(rotation, target_angle, rotation_speed * _delta)
	scale.y = -1 if direction.x < 0 else 1
