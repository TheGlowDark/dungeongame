extends State

@onready var enemy = $"../.."

func enter():
	enemy.update_animation(enemy.get_distance().normalized())
	enemy.animation_travel("death")
	enemy._die()
