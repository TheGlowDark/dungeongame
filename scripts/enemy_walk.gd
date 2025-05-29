extends State

@onready var enemy = $"../.."

func enter():
	enemy.animation_travel("walk")
	
func update(_delta):
	if enemy.health <= 0:
		state_transition.emit(self, "death")
	enemy.velocity = enemy.get_distance().normalized() * Vector2(1, -1) * enemy.speed
	enemy.update_animation(enemy.get_distance().normalized())
	if(enemy.get_distance().length() <= enemy.attack_distance):
		enemy.velocity = Vector2.ZERO
		state_transition.emit(self, "attack")
