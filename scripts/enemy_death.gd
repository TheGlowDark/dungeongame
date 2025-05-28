extends State

@onready var enemy = $"../.."

func enter():
	enemy.update_animation(enemy.get_distance().normalized)
	enemy.animation_travel("death")
	await enemy.animator_player.animation_finished
	enemy._die()
