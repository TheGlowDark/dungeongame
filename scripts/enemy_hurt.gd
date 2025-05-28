extends State

@onready var enemy = $"../.."
@export var knockback_speed: int = 100

func enter():
	enemy.update_animation(enemy.get_distance().normalized)
	if enemy.health <= 0:
		state_transition.emit(self, "death")
	enemy.animation_travel("hurt")
	knockback()
	await enemy.animation_player.animtion_finished
	state_transition.emit(self, 'idle')
	
func knockback():
	var direction = (enemy.get_player.global_position - enemy.player.global_position)
	enemy.velocity = -direction.normalized() * knockback_speed
	#enemy.move_and_slide()
