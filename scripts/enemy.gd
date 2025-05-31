extends character_base
class_name Enemy
@export var attack_distance = 128
@export var speed = 100
@onready var fsm = $state_machine
@onready var animation_player = $AnimationPlayer
@export var attack_cooldown = 2.0
@onready var navagent = $NavigationAgent2D 
@onready var room = $"../../"
@export var damage = 1
var active = false

var can_attack = true
var is_attacking = false

func play_animation(s):
	animation_player.play(s)
	await animation_player.animation_finished

func _ready():
#	process_mode = PROCESS_MODE_DISABLED
#	fsm.process_mode = PROCESS_MODE_DISABLED
	animation_tree.active = true
	update_animation(Vector2.LEFT)
	
func activate_enemy():
	process_mode = PROCESS_MODE_ALWAYS
	fsm.process_mode = PROCESS_MODE_ALWAYS
	fsm.change_state(fsm.initial_state, "wait")



func _physics_process(_delta: float):
	move_and_slide()

func get_distance():
	var dist = to_local(navagent.get_next_path_position())
	#dist.y *= -1
	return dist

func makepath_to_player():
	navagent.target_position = get_player.global_position


func _on_path_check_timeout() -> void:
	makepath_to_player()

	
