extends State
@onready var player = $"../.."


func enter():
	player.is_alive = false
	player.animation_travel("death")
