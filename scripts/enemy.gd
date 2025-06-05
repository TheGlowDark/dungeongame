extends character_base
class_name Enemy
@export var attack_distance = 128
@export var speed_base = 100
var speed = speed_base
@export var score = 100
@onready var animation_player = $AnimationPlayer
@export var attack_cooldown = 2.0
@onready var navagent = $NavigationAgent2D 
@onready var room = $"../../"
@export var damage = 1
@export var attack_delay = 1.0

var active = false

var can_attack = true
var is_attacking = false

func play_animation(s):
	animation_player.play(s)
	await animation_player.animation_finished

func _ready():
	speed = speed_base * Global.dif_multiplier
#	process_mode = PROCESS_MODE_DISABLED
#	fsm.process_mode = PROCESS_MODE_DISABLED
	animation_tree.active = true
	update_animation(Vector2.LEFT)
	
func activate_enemy():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	fsm.process_mode = Node.PROCESS_MODE_PAUSABLE
	fsm.change_state(fsm.initial_state, "wait")

func stun(attack_stun_time):
	set_process(false)
	set_physics_process(false)
	await get_tree().create_timer(attack_stun_time).timeout 
	set_process(true)
	set_physics_process(true)


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

	
