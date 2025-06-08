extends State

@onready var player := $"../.."
@export var step_cooldown = 0.2

@export var sound1: AudioStreamWAV
@export var sound2: AudioStreamWAV
@export var sound3: AudioStreamWAV

@onready var sounds = [sound1, sound2, sound3]
var time_since_last_step: float = step_cooldown
var step_index: int = 0



func enter():
	time_since_last_step = step_cooldown
	if player:
		player.animation_travel("walk")


func update(delta : float):
	if player.health <= 0:
		state_transition.emit(self, "death")
		return
	player.update_animation(player.update_look_direction())
	
	time_since_last_step += delta
	step_sounds()
		
	var input_dir = player.get_input()
	move(input_dir, delta)

	if Input.is_action_just_pressed("attack") and player.can_attack:
		state_transition.emit(self, "attack")
#	elif Input.is_action_just_pressed("special_attack") and player.can_attack and player.sword_progress == 3:
#		state_transition.emit(self, "attack")	
	#	player.is_special_attack = true

func move(input_dir: Vector2, _delta: float):
	player.velocity = input_dir * player.speed
	# flipping sprite if needed

	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		state_transition.emit(self, "idle")
	player.move_and_slide()

func step_sounds():
	if time_since_last_step >= step_cooldown:
		AudioManager.play_sound(sounds[step_index], 0, 0.1)
		step_index += 1
		step_index %= sounds.size()
		time_since_last_step = 0
