extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D  # Лучше использовать CharacterBody2D для движущихся объектов
@export var speed: float = 150.0
@export var attack_range: float = 64.0  # Дистанция для атаки
@export var attack_cooldown: float = 1.0  # Задержка между атаками

var player: Player
var can_attack: bool = true
var attack_timer: Timer

func enter():
	# Ищем игрока при входе в состояние
	player = get_tree().get_first_node_in_group("player")
	
	# Создаем таймер для атаки
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_cooldown_finished)
	add_child(attack_timer)

func exit():
	if attack_timer:
		attack_timer.queue_free()

func physics_process(delta: float):
	if not player:
		return
	
	var direction = player.global_position - enemy.global_position
	var distance = direction.length()
	
	# Если игрок в радиусе атаки
	if distance <= attack_range and can_attack:
		attack()
	# Если игрок вне радиуса атаки, но в радиусе преследования
	elif distance > attack_range and distance < 500:  # 500 - максимальная дистанция преследования
		enemy.velocity = direction.normalized() * speed
	else:
		enemy.velocity = Vector2.ZERO
	
	enemy.move_and_slide()

func attack():
	if not can_attack:
		return
	
	# Здесь код атаки
	
	# Запускаем анимацию атаки
	if enemy.has_method("play_attack_animation"):
		enemy.play_attack_animation()
	
	# Наносим урон игроку
	if player.has_method("take_damage"):
		player.take_damage(1)  # 10 - урон
	
	can_attack = false
	attack_timer.start()

func _on_attack_cooldown_finished():
	can_attack = true
