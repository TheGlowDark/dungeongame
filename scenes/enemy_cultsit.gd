extends character_base
class_name Enemy
@export var attack_distance = 128
@export var speed = 100
@onready var fsm = $state_machine
@onready var get_player:= get_tree().get_nodes_in_group("player")[0]
@onready var attack_timer = $Timer
@export var attack_cooldown = 2.0
@onready var navagent = $NavigationAgent2D 
@onready var raycast = $ShapeCast2D
var can_attack = true

func _ready():
	animation_tree.active = true
	update_animation(Vector2.LEFT)

func _physics_process(_delta: float):
	move_and_slide()

func get_distance():
	var dist = to_local(navagent.get_next_path_position())
	#dist.y *= -1
	return dist

func makepath_to_player():
	navagent.target_position = get_player.global_position

func player_attack_check() -> bool:
	raycast.target_position = to_local(get_player.global_position)
	raycast.force_shapecast_update()
#	print(!raycast.is_colliding())
	return !raycast.is_colliding()


func _on_path_check_timeout() -> void:
	makepath_to_player()
