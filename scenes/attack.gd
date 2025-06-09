
extends State

@onready var player := $"../.."
@onready var weapon := $"../../weapon"
@onready var special_sword := preload("res://scenes/special_sword.tscn")
@export var swing_durability = 0.5
@export var sound: AudioStreamWAV

var is_dashing = false 
@export var dashing_duration = 0.1
var dashing_timer = dashing_duration
@onready var dash_direction: Vector2
func enter():
	$"../../CollisionShape2D".debug_color = Color(1, 0, 0, 0.4)
	AudioManager.play_sound(sound, 0, 0.2)
	player.is_attack = true
	weapon.attack()
	player.can_attack = false
	dashing_timer = dashing_duration
	dash_direction = player.update_look_direction()
		# Устанавливаем позицию пули в позицию точки спавна
		# Направление пули к игроку
	
	#if player:
		#player.animation_travel("attack")


func update(delta : float):
	if player.health <= 0:
		state_transition.emit(self, "death")
#	move(dash_direction, delta)
	if dashing_timer >= 0:
		dashing_timer -= delta
	else:
		await weapon.animationplayer.animation_finished
		weapon.idle()
		player.is_attack = false
		state_transition.emit(self, 'idle')
	move(dash_direction, delta)
func move(input_dir: Vector2, _delta: float):
	player.velocity = input_dir * player.attack_speed_boost
	# flipping sprite if needed

	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		state_transition.emit(self, "idle")
	#player.move_and_slide()
