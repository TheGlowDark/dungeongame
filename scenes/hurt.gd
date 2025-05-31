extends State

@onready var player := $"../.."

func enter():
	if player.health <= 0:
		state_transition.emit(self, "death")
	player.animation_travel("hurt")
	state_transition.emit(self, "idle")
	player.update_hp_icons()
