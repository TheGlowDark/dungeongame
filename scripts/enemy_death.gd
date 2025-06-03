extends State

@onready var enemy = $"../.."
@export var sound: AudioStreamWAV

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.update_animation(enemy.get_distance().normalized() * Vector2(1, -1))
	enemy.animation_travel("death")
	enemy.room.enemies_count -= 1
	enemy.room.clear_check()
	AudioManager.play_sound(sound, 0, 0.3)
	await get_tree().create_timer(5).timeout
	enemy._die()
