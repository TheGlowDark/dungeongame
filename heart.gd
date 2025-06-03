extends Sprite2D
@export var amount = 1
@onready var player:= get_tree().get_nodes_in_group("player")[0]
@onready var animation_player = $AnimationPlayer
@export var appear_sound: AudioStreamWAV
@export var pick_up_sound: AudioStreamWAV
@export var spawn_delay: float
var is_spawned = false

#func _ready() -> void:
	#animation_player.play("RESET")

func appear():
	animation_player.play("appear")
	AudioManager.play_sound(appear_sound, 0, 0.2)
	await animation_player.animation_finished
	is_spawned = true
	animation_player.play("idle")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.health < 3 and is_spawned:
		AudioManager.play_sound(pick_up_sound, 0, 0.2)
		player.hp_up(amount)
		queue_free()
