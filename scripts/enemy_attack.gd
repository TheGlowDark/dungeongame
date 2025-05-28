extends State 
@onready var enemy = $"../.."
@onready var bulletspawnpoint = $"../../bullletspawn"
@onready var bullet := preload("res://scenes/bullet.tscn")

func enter():
	if enemy.attack_timer.is_stopped():
		enemy.animation_travel("attack")
		enemy.velocity = Vector2.ZERO
		enemy.attack_timer.wait_time = 2.0
		enemy.attack_timer.start()
		enemy.can_attack = false
		

func update(_delta):
	enemy.update_animation(enemy.get_distance().normalized())
	if enemy.health == 0:
		state_transition.emit(self, "death")
	if enemy.attack_timer.is_stopped():
		state_transition.emit(self, "walk")
	

func exit():
	var b = bullet.instantiate()
	enemy.get_parent().add_child(b)
	# Устанавливаем позицию пули в позицию точки спавна
	# Направление пули к игроку
	b.global_position = bulletspawnpoint.global_position
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		b.direction = (players[0].global_position - b.global_position).normalized()
