extends Node2D
class_name Room

var room_position = Vector2.ZERO
#var id = str(room_position)

@onready var get_player:= get_tree().get_nodes_in_group("player")[0]
@onready var fog = $ColorRect
var is_entered = false
var enemies_count = 0
var is_current = false

func clear_check():
	return enemies_count <= 0



#func _ready() -> void:
	#process_mode = PROCESS_MODE_DISABLED
