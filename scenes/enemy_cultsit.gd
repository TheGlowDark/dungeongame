extends Enemy
class_name Enemy_cultist

@onready var attack_timer = $attack_cooldown
@onready var bulletspawnpoint = $bullletspawn
@onready var bullet := preload("res://scenes/bullet.tscn")
@onready var raycast = $ShapeCast2D
@export var attack_delay = 1.6


func attack():
	if can_attack and player_attack_check():
		await get_tree().create_timer(attack_delay).timeout
		var b = bullet.instantiate()
		get_parent().get_parent().add_child(b)
		can_attack = false
		# Устанавливаем позицию пули в позицию точки спавна
		# Направление пули к игроку
		b.global_position = bulletspawnpoint.global_position
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			b.direction = (players[0].global_position - b.global_position).normalized()

func _ready():
	process_mode = PROCESS_MODE_DISABLED
	fsm.process_mode = PROCESS_MODE_DISABLED
	animation_tree.active = true
	update_animation(Vector2.LEFT)
#

func _physics_process(_delta: float):
#if room.is_current:
#		process_mode = Node.PROCESS_MODE_INHERIT
	#aprint("!")
	#if room.is_current:
	#	process_mode = Node.PROCESS_MODE_INHERIT
	move_and_slide()

func player_attack_check() -> bool:
	raycast.target_position = to_local(get_player.global_position)
	raycast.force_shapecast_update()
#	print(!raycast.is_colliding())
	return !raycast.is_colliding()

#	if room.is_current:
#		process_mode = Node.PROCESS_MODE_INHERIT
	#move_and_slide()

#func get_distance():
	#var dist = to_local(navagent.get_next_path_position())
	##dist.y *= -1
	#return dist
#
#func makepath_to_player():
	#navagent.target_position = get_player.global_position
#
#
#func _on_path_check_timeout() -> void:
	#makepath_to_player()

	
