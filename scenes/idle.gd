extends State
class_name enemy_idle

@export var enemy: Character
@export var speed: float

func Physics_update(delta:float):
	if enemy:
		enemy.velocity = Vector2(-1, 0) * speed 
