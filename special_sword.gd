extends Sprite2D

@export var speed := 300
@onready var weapon = $"../"
var direction := Vector2.ZERO


func ready():
	rotation = weapon.rotation
	global_position = weapon.global_position
	direction = weapon.direction

#func _ready() -> void:
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
	if body is Enemy:  # Или body.is_in_group("player")
		body._take_damage(1)
		print(body.health)
	if not body is character_base: 
		queue_free()  # Уничтожаем пулю после попадания
