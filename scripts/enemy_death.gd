extends State

@onready var enemy = $"../.."
@export var sound: AudioStreamWAV
@export var death_time = 5

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.update_animation(enemy.get_distance() * Vector2(1, -1))
	enemy.animation_travel("death")
	enemy.room.enemies_count -= 1
	enemy.room.clear_check()
	$"../../CollisionShape2D".debug_color = Color(0, 0, 0, 0.4)
	Global.score += Global.kill_score(enemy.score)
	AudioManager.play_sound(sound, 0, 0.3)
	await get_tree().create_timer(death_time).timeout
	enemy._die()
