#extends CharacterBody2D
#class_name Player
## Настройки движения
#@export var speed: float = 200
#
#@onready var animation_tree = $AnimationTree
#@onready var animation_state_machine = animation_tree.get("parameters/playback")
#
##@export var acceleration: float = 8
##@export var friction: float = 10
#
## Переменные состояния
#var input_vector: Vector2 = Vector2.ZERO
#var last_direction: Vector2 = Vector2.DOWN  # Для анимации
#
#func _ready():
	#update_animation(last_direction)
#
#
#
#func _physics_process(_delta):
	## Получаем ввод игрока
	#get_input()
	#if Input.is_action_just_pressed("clickright"):
		#$Camera2D.zoom /= 2
	#if Input.is_action_just_pressed("clickleft"):
		#$Camera2D.zoom *= 2
	## Обрабатываем движение
	#handle_movement(_delta)
	## Обновляем анимацию
	#update_animation(velocity)
	## Применяем движение
	#move_and_slide()
	#
	#pick_new_state()
#
#func get_input():
	## Обновляем последнее направление для анимации
	#if input_vector != Vector2.ZERO:
		#last_direction = input_vector
		#
	#input_vector= Vector2(
	#Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	#Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	#
	#
#
#func handle_movement(_delta):
	## Плавное ускорение и замедлениев
	#if input_vector != Vector2.ZERO:
		##velocity = velocity.lerp(input_vector * speed, acceleration * _delta)
		#velocity = input_vector * speed
		##print(z_index)
	##	print(position)
	#else:
		##velocity = velocity.lerp(Vector2.ZERO, friction * _delta)
		#velocity = Vector2.ZERO
		#
		#
## parameters/idle/blend_position
#func update_animation(move_input: Vector2):
	#if last_direction == Vector2.UP:
		#$weapon.z_index = -1
	#else:
		#$weapon.z_index = 1
	#if move_input != last_direction and move_input != Vector2.ZERO:
		#animation_tree.set("parameters/idle/blend_position", move_input)
		#animation_tree.set("parameters/walk/blend_position", move_input)
	#
#func pick_new_state():
	#if(velocity != Vector2.ZERO):
		#animation_state_machine.travel("walk")
	#else:
		#animation_state_machine.travel("idle")
extends character_base
class_name Player

# Настройки движения
@export var speed = 70
@export var start_position: Vector2
@export var attack_speed_boost = 100
var can_attack := true
@export var attack_cooldown := 0.5
var attack_cooldown_timer = attack_cooldown

# Переменные состояния
var input_vector: Vector2 = Vector2.ZERO
var look_direction: Vector2 = Vector2.DOWN  # Направление взгляда (к курсору)

func _ready():
	animation_tree.active = true
	update_animation(look_direction)
#	$state_machine.character = self  # Важно передать ссылку на персонажа

func _physics_process(_delta):
	if not can_attack:
		attack_cooldown_timer -= _delta
		if attack_cooldown_timer <= 0:
			can_attack = true
			attack_cooldown_timer = attack_cooldown
	#print(can_attack)
	# StateMachine теперь управляет всем
	#get_input()
#	$state_machine._physics_process(delta)
	move_and_slide()


func get_input():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

func update_look_direction():
	# Получаем позицию мыши в мировых координатах
	var mouse_pos = get_global_mouse_position()
	# Вычисляем направление от персонажа к курсору
	look_direction = (mouse_pos - global_position).normalized()
	
	# Обновляем положение оружия (если нужно)
	if look_direction.y < 0:  # Если смотрим вверх
		$weapon.z_index = -1
	else:
		$weapon.z_index = 1
	return look_direction

#func handle_movement(delta):
	#if input_vector != Vector2.ZERO:
		#velocity = input_vector * speed
	#else:
		#velocity = Vector2.ZERO

#func update_animation(direction: Vector2):
	## Устанавливаем blend_position для анимаций
	#if(direction != Vector2.ZERO):
		#animation_tree.set("parameters/idle/blend_position", direction)
		#animation_tree.set("parameters/walk/blend_position", direction)
		#animation_tree.set("parameters/hurt/blend_position", direction)
		#animation_tree.set("parameters/death/blend_position", direction)
		#animation_tree.set("parameters/attack/blend_position", direction)
#
#
#func animation_travel(state: String):
	#if animation_state_machine != null:
		#animation_state_machine.travel(state)
#	else:
#		push_error("Cannot travel - state machine is null")


#func pick_new_state():
	#if velocity != Vector2.ZERO:
		#animation_state_machine.travel("walk")
	#else:
		#animation_state_machine.travel("idle")
