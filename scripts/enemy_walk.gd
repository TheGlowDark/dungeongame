extends State

@onready var enemy = $"../.."
@export var attack_distance = 128

func enter():
	enemy.animation_travel("walk")
	
func update(_delta):
	if enemy.health <= 0:
		state_transition.emit(self, "death")
	var distance = (enemy.player.global_position - enemy.global_position)
	enemy.velocity = distance * enemy.speed
	if(distance <= attack_distance):
		state_transition.emit(self, "attack")
