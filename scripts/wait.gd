extends State

@onready var enemy = $"../.."
@export var waiting_time = 0.5

func enter():
	enemy.animation_travel("idle")
	#print("!")
	await get_tree().create_timer(waiting_time).timeout
	state_transition.emit(self, "idle")
