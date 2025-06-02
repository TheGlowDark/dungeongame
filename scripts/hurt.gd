extends State

@onready var enemy = $"../.."


func enter():
	if enemy.health <= 0:
		state_transition.emit(self, "death")
		return
	#if(enemy.stun_time != 0):
	enemy.animation_travel("hurt")
	print("!")
	await get_tree().create_timer(enemy.stun_time).timeout 
	state_transition.emit(self, "idle")
