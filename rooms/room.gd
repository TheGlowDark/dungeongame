extends Room
class_name Dungeon_room

@onready var enemies_list = $Enemies
@onready var dropped_items = $items
@onready var fog = $ColorRect
func hp_drop():
	if randi_range(1, 100) <= hp_chance_drop:
		var h = heart.instantiate()
		dropped_items.add_child(h)
		h.appear()

func _ready():
	enemies_count = enemies_list.get_child_count()
	#clear_check()
	
func _on_area_2d_body_entered(body) -> void:
	if body is Player and is_instance_valid(fog):
	#	get_tree().call_group(id, "set_process_mode", Node.PROCESS_MODE_INHERIT)
		fog.queue_free()
		is_entered = true
		is_current = true
		if is_instance_valid(enemies_list):
			for enemy in enemies_list.get_children():
				enemy.activate_enemy()
				
func _on_area_2d_body_exited(body) -> void:
	if body is Player:
		is_current = false
