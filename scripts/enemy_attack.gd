extends State

@onready var enemy = $"../.."
@export var attack: AudioStreamWAV
func enter():
	#if enemy.health <= 0:
		#state_transition.emit(self, "death")
	
	# Если игрок в зоне и можно атаковать
	if enemy.player_attack_check() and enemy.can_attack:
		enemy.animation_travel("attack")
		AudioManager.play_sound(attack, 0, 0.1)
		enemy.attack_timer.start(enemy.attack_cooldown)
		enemy.velocity = Vector2.ZERO  # Останавливаем движение
		enemy.attack()  # Запускаем атаку
		state_transition.emit(self, "idle")  # Иначе возвращаемся в idle
		#await enemy.attack_timer.timeout
	#else:

func update(_delta: float):
	#enemy.update_animation(enemy.get_distance().normalized() * Vector2(1, -1))
	if enemy.health <= 0:
		state_transition.emit(self, "death")
		return
	if !enemy.get_player.is_alive:
		state_transition.emit(self, "start")
		return
	#enemy.update_animation(enemy.get_distance().normalized() * Vector2(1, -1))
	# Если таймер атаки закончился и игрок всё ещё в зоне
	if enemy.attack_timer.is_stopped():
		enemy.can_attack = true
		state_transition.emit(self, "idle")  # Иначе возвращаемся в idle
	#else:
	#d	state_transition.emit(self, "attack")  # Атакуем снова




#extends State 
#@onready var enemy = $"../.."
#
#func enter():
	#if enemy.health <= 0:
		#state_transition.emit(self, "death")
		#return
	#if enemy.attack_timer.is_stopped():
		#enemy.animation_travel("attack")
		##enemy.velocity = Vector2.ZERO
		#enemy.attack_timer.wait_time = enemy.attack_cooldown
		#enemy.attack_timer.start()
		#enemy.can_attack = false
		#enemy.attack()
	#else:
		#state_transition.emit(self, "idle")
		#
		#
#
#func update(_delta):
	#if enemy.health <= 0:
		#state_transition.emit(self, "death")
	##enemy.update_animation(enemy.get_distance().normalized() * Vector2(1, -1))
	#if enemy.attack_timer.is_stopped():
		#state_transition.emit(self, "idle")
	#
#
##func exit():
	##var b = bullet.instantiate()
	##enemy.get_parent().get_parent().add_child(b)
	### Устанавливаем позицию пули в позицию точки спавна
	### Направление пули к игроку
	##b.global_position = bulletspawnpoint.global_position
	##var players = get_tree().get_nodes_in_group("player")
	##if players.size() > 0:
		##b.direction = (players[0].global_position - b.global_position).normalized()
