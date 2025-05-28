extends character_base
class_name enemy

@onready var fsm = $state_machine
var player: Player

func _ready():
	animation_tree.active = true
	update_animation(Vector2.LEFT)


func _physics_process(_delta: float):
	move_and_slide()
