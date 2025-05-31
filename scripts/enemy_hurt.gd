extends State

@onready var enemy = $"../.."
@export var knockback_speed: int = 100

func enter():
	if enemy.health <= 0:
		state_transition.emit(self, "death")
	enemy.update_animation(enemy.get_distance().normalized)
	enemy.animation_travel("hurt")
	await enemy.animation_player.animtion_finished
	state_transition.emit(self, 'idle')
	
