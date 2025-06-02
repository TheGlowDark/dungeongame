extends State

@onready var player := $"../.."


func enter():
	if player:
		player.animation_travel("walk")


func update(delta : float):
	if player.health <= 0:
		state_transition.emit(self, "death")
	player.update_animation(player.update_look_direction())
	
	var input_dir = player.get_input()
	move(input_dir, delta)

	if Input.is_action_just_pressed("attack") and player.can_attack:
		state_transition.emit(self, "attack")
	elif Input.is_action_just_pressed("special_attack") and player.can_attack and player.sword_progress == 3:
		state_transition.emit(self, "attack")	
		player.is_special_attack = true

func move(input_dir: Vector2, _delta: float):
	player.velocity = input_dir * player.speed
	# flipping sprite if needed

	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		state_transition.emit(self, "idle")
	player.move_and_slide()
