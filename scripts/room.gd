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



#func _ready() -> void:
	#process_mode = PROCESS_MODE_DISABLED


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_entered and body is Player: #and body.active:
		for child in doors.get_children():
			child.open()
		is_entered = true
