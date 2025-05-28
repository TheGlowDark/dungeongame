extends State

@onready var enemy = $"../.."

func enter():
	enemy.animation_travel("idle")
	
func update(_delta):
	enemy.velocity = Vector2.ZERO
	if(enemy.player.global_position.distance_to(enemy.global_position) <= 256):
		state_transition.emit(self, "walk")
