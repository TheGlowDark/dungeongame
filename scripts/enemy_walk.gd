extends State

@onready var enemy = $"../.."

func enter():
	enemy.animation_travel("walk")
	
func update(_delta):
	enemy.update_animation(enemy.get_distance().normalized())
	if enemy.health <= 0:
		state_transition.emit(self, "death")
	enemy.velocity = enemy.get_distance().normalized() * Vector2(1, -1) * enemy.speed
	if(enemy.get_distance().length() <= enemy.attack_distance):
		state_transition.emit(self, "attack")
