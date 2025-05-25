extends Area2D
#куда дверь телепортирует игрока
@export var next_pos:Vector2
#Задаём переменную телепорта
func set_next_pos(vector):
	next_pos = vector
#Возвращаем эту переменную
func get_next_pos():
	return next_pos

func _on_body_entered(body: Node):
	if body is Player:
		body.global_position = next_pos
	
#func _on_body_exited(body: Node):
	##
