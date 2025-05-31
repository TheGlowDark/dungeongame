extends State

@onready var enemy = $"../.."

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.update_animation(enemy.get_distance().normalized() * Vector2(1, -1))
	enemy.animation_travel("death")
	enemy.room.enemies_count -= 1
	enemy._die()
