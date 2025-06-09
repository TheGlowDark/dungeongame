extends State

@onready var enemy = $"../.."
@onready var navagent = $"../../NavigationAgent2D"

func enter():
	enemy.animation_travel("walk")
	
func update(_delta):
	$"../../CollisionShape2D".debug_color = Color(0, 1, 0, 0.4)
	enemy.update_animation(enemy.get_distance() * Vector2(1, -1))
	if enemy.health <= 0:
		state_transition.emit(self, "death")
		return
	if !enemy.player_attack_check():
		enemy.velocity = enemy.get_distance() * enemy.speed
	else:
		state_transition.emit(self, "attack")
	#	if !enemy.player_attack_check():
