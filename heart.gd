extends Sprite2D
@export var amount = 1
@onready var player:= get_tree().get_nodes_in_group("player")[0]
@onready var animation_player = $AnimationPlayer

func appear():
	animation_player.play("appear")
	await animation_player.animation_finished
	animation_player.play("idle")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.health < 3:
		player.hp_up(amount)
		queue_free()
