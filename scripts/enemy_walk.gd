extends State

@onready var enemy = $"../.."
@onready var navagent = $"../../NavigationAgent2D"

func enter():
	enemy.animation_travel("walk")
	
func update(_delta):
	if enemy.health <= 0:
		state_transition.emit(self, "death")
	enemy.velocity = enemy.get_distance().normalized() * enemy.speed
	enemy.update_animation(enemy.get_distance().normalized() * Vector2(1, -1))
	if(enemy.player_attack_check()):
		enemy.velocity = Vector2.ZERO
		state_transition.emit(self, "attack")
