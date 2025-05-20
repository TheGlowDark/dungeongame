extends Node

@export var tilemap: TileMap
@export var room_templates: Array[PackedScene]
@export var room_size: Vector2i = Vector2i(10, 10)
@export var max_rooms: int = 10

var current_room: Node2D
var room_grid := {}
var room_count := 0

func _ready():
	generate_dungeon()

func generate_dungeon():
	# Создаем стартовую комнату
	var start_room = room_templates[0].instantiate()
	$RoomsContainer.add_child(start_room)
	current_room = start_room
	room_grid[Vector2i(0, 0)] = start_room
	room_count += 1
	
	# Генерируем комнаты
	generate_connected_rooms(start_room, Vector2i(0, 0))

func generate_connected_rooms(room: Node2D, grid_pos: Vector2i):
	var directions = [
		Vector2i(0, 1),  # Север
		Vector2i(1, 0),  # Восток
		Vector2i(0, -1), # Юг
		Vector2i(-1, 0)  # Запад
	]
	
	for dir in directions:
		if room_count >= max_rooms:
			return
			
		var new_grid_pos = grid_pos + dir
		if not room_grid.has(new_grid_pos) and randf() < 0.6:
			var new_room = room_templates.pick_random().instantiate()
			$RoomsContainer.add_child(new_room)
			new_room.position = Vector2(
				new_grid_pos.x * room_size.x * tilemap.tile_set.tile_size.x,
				new_grid_pos.y * room_size.y * tilemap.tile_set.tile_size.y
			)
			room_grid[new_grid_pos] = new_room
			room_count += 1
			
			# Генерируем тайлы комнаты в основном TileMap
			generate_room_tiles(new_room, new_grid_pos)
			
			# Создаем двери
			create_door_between(room, new_room, dir)
			
			# Рекурсивно продолжаем генерацию
			generate_connected_rooms(new_room, new_grid_pos)

func generate_room_tiles(room: Node2D, grid_pos: Vector2i):
	var start_x = grid_pos.x * room_size.x
	var start_y = grid_pos.y * room_size.y
	
	# Генерация пола
	for x in room_size.x:
		for y in room_size.y:
			tilemap.set_cell(0, Vector2i(start_x + x, start_y + y), 0, Vector2i(0, 0))
	
	# Генерация стен
	for x in room_size.x:
		tilemap.set_cell(1, Vector2i(start_x + x, start_y), 0, Vector2i(1, 0))
		tilemap.set_cell(1, Vector2i(start_x + x, start_y + room_size.y - 1), 0, Vector2i(1, 0))
	for y in room_size.y:
		tilemap.set_cell(1, Vector2i(start_x, start_y + y), 0, Vector2i(1, 0))
		tilemap.set_cell(1, Vector2i(start_x + room_size.x - 1, start_y + y), 0, Vector2i(1, 0))
	
	# Оставляем проходы для дверей
	tilemap.set_cell(1, Vector2i(start_x + room_size.x / 2, start_y), -1)
	tilemap.set_cell(1, Vector2i(start_x + room_size.x / 2, start_y + room_size.y - 1), -1)
	tilemap.set_cell(1, Vector2i(start_x, start_y + room_size.y / 2), -1)
	tilemap.set_cell(1, Vector2i(start_x + room_size.x - 1, start_y + room_size.y / 2), -1)
	
func create_door_between(room_a, room_b, direction):
	var dir_str = ""
	var opposite_dir = ""
	
	match direction:
		Vector2i(0, 1): dir_str = "North"; opposite_dir = "South"
		Vector2i(1, 0): dir_str = "East"; opposite_dir = "West"
		Vector2i(0, -1): dir_str = "South"; opposite_dir = "North"
		Vector2i(-1, 0): dir_str = "West"; opposite_dir = "East"
	
	# Создаем дверь в комнате A
	var door_a = preload("res://scenes/door.tscn").instantiate()
	room_a.get_node("DoorMarkers/" + dir_str).add_child(door_a)
	door_a.target_room = room_b
	door_a.door_direction = dir_str
	
	# Создаем дверь в комнате B
	var door_b = preload("res://scenes/door.tscn").instantiate()
	room_b.get_node("DoorMarkers/" + opposite_dir).add_child(door_b)
	door_b.target_room = room_a
	door_b.door_direction = opposite_dir
	
