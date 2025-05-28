extends State

@onready var player := $"../.."
@export var swing_durability = 0.5
var is_dashing = false 
@export var dashing_duration = 0.1
var dashing_timer = dashing_duration
@onready var dash_direction: Vector2
func enter():
	player.can_attack = false
	dashing_timer = dashing_duration
	dash_direction = player.update_look_direction()
	#if player:
		#player.animation_travel("attack")


func update(delta : float):
	if player.health <= 0:
		state_transition.emit(self, "death")
	move(player.update_look_direction(), delta)
	if dashing_timer >= 0:
		dashing_timer -= delta
	else:
		state_transition.emit(self, 'idle')

func move(input_dir: Vector2, _delta: float):
	player.velocity = input_dir * player.attack_speed_boost
	# flipping sprite if needed

	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		state_transition.emit(self, "idle")
	player.move_and_slide()
