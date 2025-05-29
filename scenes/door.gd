extends Area2D
#куда дверь телепортирует игрока
@export var next_pos:Vector2
@onready var room = $"../"
@onready var side = 0 

#Задаём переменную телепорта
func set_next_pos(vector):
	next_pos = vector
#Возвращаем эту переменную
func get_next_pos():
	return next_pos

func _on_body_entered(body: Node):
	if body is Player and room.clear_check():
		var transition = Vector2.ZERO
		body.global_position = next_pos
		#match side:
			#0: player.
			#1:
			#2:
			#3:
		body.current_room += Vector2()
#func _on_body_exited(body: Node):
