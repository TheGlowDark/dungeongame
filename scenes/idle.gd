extends State

@onready var player := $"../.."

func enter():
	player.animation_travel("idle")
	
func update(_delta):
	if player.health <= 0:
		state_transition.emit(self, "death")
	player.update_animation(player.update_look_direction())
	var input_dir = player.get_input()
	move(input_dir, _delta)
	if(input_dir != Vector2.ZERO):
		state_transition.emit(self, "walk")
	#player.update_animation(input_dir)
	#player.move_and_slide()
	if Input.is_action_just_pressed("attack") and player.can_attack:
		state_transition.emit(self, "attack")	
	

func move(input_dir: Vector2, _delta: float):
	player.velocity = input_dir * player.speed
	# flipping sprite if needed

	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		state_transition.emit(self, "idle")
	player.move_and_slide()
