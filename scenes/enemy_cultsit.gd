extends character_base
class_name Enemy
@export var attack_distance = 128
@export var speed = 100
@onready var fsm = $state_machine
@onready var get_player:= get_tree().get_nodes_in_group("player")[0]
@onready var attack_timer = $Timer
@export var attack_cooldown = 2.0

var can_attack = true

func _ready():
	animation_tree.active = true
	update_animation(Vector2.LEFT)

func _physics_process(_delta: float):
	move_and_slide()

func get_distance():
	var dist = global_position - get_player.global_position
	dist.x *= -1
	return dist
