extends Area2D

@export var speed := 300
var direction := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Двигаем пулю с постоянной скоростью
	global_position += direction * speed * _delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:  # Или body.is_in_group("player")
		body._take_damage(1)
		print(body.health)
	if not body is Enemy: 
		queue_free()  # Уничтожаем пулю после попадания
