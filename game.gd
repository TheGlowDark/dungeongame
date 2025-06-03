extends Node

var current_dungeon = null

const room_root := "res://rooms/normal_rooms/room"
const start_root := "res://rooms/start_rooms/room"
const exit_root := "res://rooms/exit_rooms/room"

var room_pool = []
var start_room_pool = []
var exit_room_pool = []

@onready var player = $Player
@export var LevelOst = AudioStreamMP3
@onready var ost = $AudioStreamPlayer2D

func get_room_path(cur_root, index: int):
	return cur_root + str(index) + ".tscn"
	
#const GRID_WIDTH = 13  # Нечетное для симметрии
#const GRID_HEIGHT = 13
#const ROOM_SIZE = 11    # Размер комнаты в тайлах (нечетное)
#const TILE_SIZE := 32  # Размер одного тайла в пикселях
#const ROOM_SIZE_PIXELS := ROOM_SIZE * TILE_SIZE  # Общий размер комнаты в пикселях
#var start_position = Vector2(ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2,ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2)



func _ready():
	ost.play()
	get_room_array(room_root, room_pool)
	get_room_array(exit_root, exit_room_pool)
	get_room_array(start_root, start_room_pool)
	generate_new_level()
	#AudioManager.play_sound(LevelOst, 0, 0.3)
func generate_new_level():
	#player.active = false
	if current_dungeon:
		current_dungeon.queue_free()
	
	current_dungeon = preload("res://scenes/level.tscn").instantiate()
	add_child(current_dungeon)
	# Явно устанавливаем позицию игрока после создания нового уровня
	player.position = current_dungeon.start_position
	player.update_floor()
	if Global.current_level != 1: #Увеличение сложности после каждого этажа
		Global.floor_up()
	#map.initializate()
	#$Camera2D.position = current_dungeon.start_position
	#player.active = true


func get_room_array(root, pool):
	var i = 1
	while true:
		var room_path = get_room_path(root, i)
		
		# Проверяем существует ли файл
		if not FileAccess.file_exists(room_path):
			break
			
		# Пытаемся загрузить сцену
		var room_scene = load(room_path)
		if room_scene == null:
			push_error("Файл существует, но не может быть загружен: " + room_path)
			break
			
		pool.append(room_scene)
		i += 1
		
