extends Area2D

@export var speed_base = 150
var speed = speed_base * Global.dif_multiplier
var direction := Vector2.ZERO


#afunc _ready() -> void:
#	global_position = $Enemy_cultsit.global_position + Vector2(0, 6)
	# Находим игрока и рассчитываем направление один раз при созданииsa
	#global_position = get_parent().global_position
	#var players = get_tree().get_nodes_in_group("player")
	#if players.size() > 0:
		#var player = players[0]
		#print(global_position)
		#direction = (player.global_position - global_position).normalized()
	#else:
		## Если игрок не найден, уничтожаем пулю
		#queue_free()


func _physics_process(_delta: float) -> void:
	# Двигаем пулю с постоянной скоростью
	global_position += direction * speed * _delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:  # Или body.is_in_group("player")
		body._take_damage(1)
		print(body.health)
	if not body is Enemy: 
		queue_free()  # Уничтожаем пулю после попадания
