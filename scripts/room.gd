extends Node2D
class_name Room

var room_position = Vector2.ZERO
var clear = true
@onready var doors = $doors
#var id = str(room_position)

@onready var get_player:= get_tree().get_nodes_in_group("player")[0]
@onready var heart = preload("res://scenes/heart.tscn")
@export var hp_chance_drop = 20
var opensound: AudioStreamWAV = preload("res://assets/sfx/door/open.wav")
var is_entered = false
var enemies_count = 0
var is_current = false

func _ready():
	clear_check()	
	
func clear_check():
	clear = (enemies_count <= 0)
	print(enemies_count)
	if clear:
		AudioManager.play_sound(opensound, 0, 0.2)
		hp_drop()
		for child in doors.get_children():
			child.open()

func hp_drop():
	if randi_range(1, 100) <= hp_chance_drop and self is Dungeon_room:
		var dropped_items = $items
		var h = heart.instantiate()
		dropped_items.add_child(h)

#func _ready() -> void:
	#process_mode = PROCESS_MODE_DISABLED


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_entered and body is Player and body.active:
		clear_check()
		is_entered = true
