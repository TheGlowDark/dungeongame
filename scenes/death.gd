extends State
@onready var player = $"../.."
@onready var deathscreen = $"../../UI/DeathScreen"
@export var sound: AudioStreamWAV

func enter():
	player.velocity = Vector2.ZERO
	player.animation_travel("death")
	AudioManager.play_sound(sound, 0, 1)
	await get_tree().create_timer(1).timeout 
	player.is_alive = false
	deathscreen.appear()
