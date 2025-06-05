extends Room
class_name Dungeon_room

@onready var enemies_list = $Enemies
@onready var dropped_items = $items
@onready var fog = $ColorRect
@onready var area2d = $Area2D
@export var hp_spawn_delay = 0.5
func hp_drop():
	if randi_range(1, 100) <= hp_chance_drop:
		await get_tree().create_timer(hp_spawn_delay).timeout
		var h = heart.instantiate()
		dropped_items.add_child(h)
		h.appear()

#func enable_collision():
#	$Area2D.monitoring = true
	
func clear_check():
	clear = (enemies_count <= 0)
	print(enemies_count)
	if clear:
		AudioManager.play_sound(opensound, 0, 0.2)
		hp_drop()
		for child in doors.get_children():
			child.open()


func _ready():
	enemies_count = enemies_list.get_child_count()
	fog.visible = true
	area2d.monitoring = false
	await get_tree().create_timer(0.8).timeout
	area2d.monitoring = true
	#clear_check()
	
func _on_area_2d_body_entered(body) -> void:
	if body is Player and is_instance_valid(fog): #and body.active:
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
