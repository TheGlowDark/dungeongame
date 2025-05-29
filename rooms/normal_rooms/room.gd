extends Node2D
class_name Room

var room_position = Vector2.ZERO
@onready var enemies_list = $Enemies
@onready var get_player:= get_tree().get_nodes_in_group("player")[0]
@onready var fog = $ColorRect
var s_entered = false
var is_clear = false

func ready():
	is_clear = clear_check()

func clear_check():
	return enemies_list.get_child_count() == 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and fog:
		fog.queue_free()
		
