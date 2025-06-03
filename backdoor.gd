extends Node2D

@onready var room = $".."
@onready var animation_player = $AnimationPlayer
@onready var game = get_tree().get_root().get_child(1)
var is_open = false

func open():
	is_open = true
	animation_player.play("open")
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and is_open:
		body.map.initializate()
		game.generate_new_level()
		
