#extends Enemy
#class_name Enemy_butcher
#
#@onready var attack_timer = $Timer
#@export var attack_range = 24  # Радиус атаки
#var can_attack = true  # Можно ли атаковать
#var is_player_in_range = false  # Игрок в зоне атаки?
#
#func _on_attack_range_body_entered(body: Node2D) -> void:
	#if body is Player:
		#is_player_in_range = true  # Игрок вошёл в зону
		#fsm.force_change_state("attack")  # Переход в состояние атаки
#
#func _on_attack_range_body_exited(body: Node2D) -> void:
	#if body is Player:
		#is_player_in_range = false  # Игрок вышел из зоны
#
#func player_attack_check() -> bool:
	#return is_player_in_range  # Возвращает true, если игрок в зоне атаки
#
#func attack():
	#if can_attack and is_player_in_range:
		## Наносим урон игроку (если он всё ещё в зоне)
		#var player = get_tree().get_first_node_in_group("player")
		#if player:
			#player.health -= damage
		#can_attack = false
		#attack_timer.start(attack_cooldown)  # Задержка перед следующей атакой
		
		

		
extends Enemy
class_name Enemy_butcher

@onready var attack_timer = $attack_cooldown
@export var attack_range = 24  # Радиус атаки
var is_player_in_range = false  # Игрок в зоне атаки?

#func _on_attack_range_body_entered(body: Node2D) -> void:
	#if body is Player:
		#is_player_in_range = true  # Игрок вошёл в зону
		#fsm.force_change_state("attack")  # Переход в состояние атаки
#
#func _on_attack_range_body_exited(body: Node2D) -> void:
	#if body is Player:
		#is_player_in_range = false  # Игрок вышел из зоны

func player_attack_check() -> bool:
	return is_player_in_range  # Возвращает true, если игрок в зоне атаки

#func _process(delta: float) -> void:
	#update_animation()

func attack():
	if can_attack and is_player_in_range:
		# Наносим урон игроку (если он всё ещё в зоне)
		if get_player and !get_player.is_attack:
			get_player._take_damage(damage)
	attack_timer.start()
	#attack_timer.start(attack_cooldown)  # Задержка перед следующей атакой


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and fsm.current_state != fsm.states.get("death"):
		is_player_in_range = true
		# Добавляем проверку, чтобы избежать множественных атак
		if is_attacking:
			#is_attacking = true
			await get_tree().create_timer(attack_delay).timeout
			
			# Проверяем, что игрок всё ещё в зоне после задержки
			if is_player_in_range and fsm.current_state != fsm.states.get("death"):
				fsm.change_state(fsm.current_state, "attack")
			is_attacking = false
			$Area2D/Attack_area.debug_color = Color.BLUE

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_in_range = false  # Игрок вышел из зоны
