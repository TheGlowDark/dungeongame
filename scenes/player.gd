extends CharacterBody2D

# Настройки движения
@export var speed: float = 100

@onready var animation_tree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

#@export var acceleration: float = 8
#@export var friction: float = 10

# Переменные состояния
var input_vector: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN  # Для анимации

func _ready():
	update_animation(last_direction)



func _physics_process(_delta):
	# Получаем ввод игрока
	get_input()
	if Input.is_action_just_pressed("clickright"):
		$Camera2D.zoom /= 2
	if Input.is_action_just_pressed("clickleft"):
		$Camera2D.zoom *= 2
	# Обрабатываем движение
	handle_movement(_delta)
	# Обновляем анимацию
	update_animation(velocity)
	# Применяем движение
	move_and_slide()
	
	pick_new_state()

func get_input():
	# Обновляем последнее направление для анимации
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		
	input_vector= Vector2(
	Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	
	

func handle_movement(_delta):
	# Плавное ускорение и замедлениев
	if input_vector != Vector2.ZERO:
		#velocity = velocity.lerp(input_vector * speed, acceleration * _delta)
		velocity = input_vector * speed
		#print(z_index)
	#	print(position)
	else:
		#velocity = velocity.lerp(Vector2.ZERO, friction * _delta)
		velocity = Vector2.ZERO
		
		
# parameters/idle/blend_position
func update_animation(move_input: Vector2):
	if last_direction == Vector2.UP:
		$weapon.z_index = -1
	else:
		$weapon.z_index = 1
	if move_input != last_direction and move_input != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
	
func pick_new_state():
	if(velocity != Vector2.ZERO):
		animation_state_machine.travel("walk")
	else:
		animation_state_machine.travel("idle")
