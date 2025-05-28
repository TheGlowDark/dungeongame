extends State

@onready var enemy = $"../.."

func enter():
	enemy.animation_travel("death")
	await enemy.animator_player.animation_finished
	enemy._die()
