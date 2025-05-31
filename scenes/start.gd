extends State

@onready var enemy = $"../.."

func enter():
	enemy.animation_travel("idle")
