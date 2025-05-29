extends Area2D


func _on_body_entered(body) -> void:
	print("!!")
	if body is Enemy:
		body.health -= 1
