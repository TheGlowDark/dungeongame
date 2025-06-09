extends Node2D

@onready var room = $".."
@onready var animation_player = $AnimationPlayer
@onready var game = get_tree().get_root().get_child(4)
var is_open = false

func open():
	is_open = true
	animation_player.play("open")
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and is_open and body.is_alive:
		body.active = false
		Global.current_level += 1  # Увеличиваем уровень
		#await body.wait()
		game.call_deferred("generate_new_level")
		#body.map.initializate()
		
