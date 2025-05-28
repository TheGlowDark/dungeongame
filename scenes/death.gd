extends Node
@onready var player = $"../.."


func enter():
	player.animation_travel("death")
