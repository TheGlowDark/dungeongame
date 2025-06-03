extends Sprite2D
#куда дверь телепортирует игрока
@export var next_pos:Vector2
var next_room: Vector2
@onready var room = $"../../"
@onready var animationplayer = $AnimationPlayer
@onready var side: int
@onready var is_open = false


#Задаём переменную телепорта
func set_next_pos(vector, n, r):
	next_room = r
	next_pos = vector
	side = n
	match n: #left and right rotations
		1:
			frame = 4
		3:
			frame = 11
#Возвращаем эту переменную
func get_next_pos():
	return next_pos


func open():
#	print(side)
	match side:
		0:
			animationplayer.play("open")
		1:
			animationplayer.play("open_right")
		2:
			animationplayer.play("open")
		3:
			animationplayer.play("open_left")
	is_open = true

func _on_body_entered(body):
	#print(room.enemies_count)
	if body is Player and is_open:
		#var transition = Vector2.ZERO
		print("!!")
		body.map.update(next_room)
		body.global_position = next_pos
		

#func _on_body_exited(body: Node):
