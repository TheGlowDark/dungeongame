extends State 
@onready var enemy = $"../.."
func enter():
	enemy.velocity = Vector2.ZERO

func update(_delta):
	if enemy.health == 0:
		state_transition.emit(self, "death")
	enemy.animation_travel("attack")
	await enemy.animation_player.animation_finished
	state_transition.emit(self, "Idle")
	
