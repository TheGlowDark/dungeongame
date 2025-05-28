extends State

@onready var enemy = $"../.."

func enter():
	enemy.animation_travel("idle")
	
func update(_delta):
	enemy.update_animation(enemy.get_distance().normalized())
	enemy.velocity = Vector2.ZERO
	if(enemy.get_distance().length() <= enemy.attack_distance):
		state_transition.emit(self, "attack")
	if(enemy.get_player.global_position.distance_to(enemy.global_position) <= 256):
		state_transition.emit(self, "walk")
		
