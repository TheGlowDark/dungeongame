extends State

@onready var enemy = $"../.."
@onready var room = $"../../../"

func enter():
	enemy.animation_travel("idle")
	
func update(_delta):
	if enemy.health <= 0:
		state_transition.emit(self, "death")
		return 
	enemy.update_animation(enemy.get_distance() * Vector2(1, -1))
#	if(enemy.get_distance().length() <= enemy.attack_distance):d
#		state_transition.emit(self, "attack")
		
	if(enemy.player_attack_check() and enemy.attack_timer.timeout):
		state_transition.emit(self, "attack")
	else: 
		state_transition.emit(self, "walk")
