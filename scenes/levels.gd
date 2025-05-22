extends Node
#
## Настройки генерации (можно сделать экспортируемыми для удобства настройки в редакторе)
#@export var GRID_WIDTH := 13  # Нечетное для симметрии
#@export var GRID_HEIGHT := 13
#@export var ROOM_SIZE := 11    # Размер комнаты в тайлах (нечетное)
#@export var TARGET_ROOM_COUNT := 15  # Фиксированное количество комнат
#@export var MIN_BOSS_DISTANCE := 6   # Минимальное расстояние от старта до босса
#
## Пути к папкам с комнатами
#@export_dir var normal_rooms_path := "res://rooms/normal_rooms"
#@export_dir var start_rooms_path := "res://rooms/start_rooms"
#@export_dir var boss_rooms_path := "res://rooms/boss_rooms"
#@export_dir var secret_rooms_path := "res://rooms/secret_rooms"
#
#enum RoomType {EMPTY, NORMAL, START, BOSS, SECRET}
#
#var layout = []        # 2D массив типов комнат
#var rooms = {}         # Словарь позиций и данных комнат
#var start_room_pos = Vector2i(6, 6)  # Центральная позиция (используем Vector2i для индексов)
#
## Кэш загруженных сцен комнат
#var room_scenes_cache := {
	#RoomType.NORMAL: [],
	#RoomType.START: [],
	#RoomType.BOSS: [],
	#RoomType.SECRET: []
#}
#
#func _ready():
	#randomize()
	#load_room_scenes()  # Загружаем сцены комнат из папок
	#generate_dungeon()
	#print_layout()
	## build_dungeon()  # Раскомментируйте, когда будете готовы создавать комнаты
#
#func load_room_scenes():
	## Загружаем все сцены комнат из соответствующих папок
	#load_rooms_from_folder(normal_rooms_path, RoomType.NORMAL)
	#load_rooms_from_folder(start_rooms_path, RoomType.START)
	#load_rooms_from_folder(boss_rooms_path, RoomType.BOSS)
	#load_rooms_from_folder(secret_rooms_path, RoomType.SECRET)
	#
	## Проверяем, что есть хотя бы одна комната каждого типа
	#for type in [RoomType.START, RoomType.BOSS]:
		#if room_scenes_cache[type].is_empty():
			#push_error("No rooms found for type: " + str(type))
			#room_scenes_cache[type] = room_scenes_cache[RoomType.NORMAL]  # Используем обычные комнаты как fallback
#
#func load_rooms_from_folder(folder_path: String, room_type: RoomType):
	#var dir := DirAccess.open(folder_path)
	#if dir:
		#dir.list_dir_begin()
		#var file_name := dir.get_next()
		#while file_name != "":
			#if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				#var room_scene = load(folder_path.path_join(file_name))
				#if room_scene:
					#room_scenes_cache[room_type].append(room_scene)
			#file_name = dir.get_next()
	#else:
		#push_error("Could not open directory: " + folder_path)
#
#func generate_dungeon():
	#initialize_grid()
	#generate_paths()
	#try_place_secret_rooms()
#
#func generate_paths():
	## Создание начальной комнаты
	#layout[start_room_pos.y][start_room_pos.x] = RoomType.START
	#rooms[start_room_pos] = {type = RoomType.START, connections = []}
	#
	## Генерация ветвлений
	#var attempts = 0
	#while rooms.size() < TARGET_ROOM_COUNT and attempts < 100:
		#var existing_rooms = rooms.keys()
		#var random_room_pos = existing_rooms.pick_random()
		#
		#var directions = get_available_directions(random_room_pos)
		#directions.shuffle()
		#
		#for dir in directions:
			#if rooms.size() >= TARGET_ROOM_COUNT:
				#break
			#create_branch(random_room_pos, dir, 1 + randi() % 3)
		#attempts += 1
	#
	#if rooms.size() < TARGET_ROOM_COUNT:
		#add_missing_rooms()
	#
	#place_boss_room()
#
#func add_missing_rooms():
	## добавляем недостающие комнаты, создавая новые ветви
	#while rooms.size() < TARGET_ROOM_COUNT:
		#var existing_rooms = rooms.keys()
		#var random_room_pos = existing_rooms[randi() % existing_rooms.size()]
		#
		#var directions = get_available_directions(random_room_pos)
		#if directions.size() > 0:
			#directions.shuffle()
			#create_branch(random_room_pos, directions[0], 1)
		#else:
			## если нет доступных направлений, прерываем цикл
			#break
#
#
#func is_valid_room_position(pos):
	#if pos.x < 0 or pos.y < 0 or pos.x >= GRID_WIDTH or pos.y >= GRID_HEIGHT:
		#return false
	#if layout[pos.y][pos.x] != RoomType.EMPTY:
		#return false
	#
	## Проверяем, чтобы не было соседей кроме предыдущей комнаты
	#var neighbors = 0
	#for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		#var check_pos = pos + dir
		#if check_pos.x < 0 or check_pos.y < 0 or check_pos.x >= GRID_WIDTH or check_pos.y >= GRID_HEIGHT:
			#continue
		#if layout[check_pos.y][check_pos.x] != RoomType.EMPTY:
			#neighbors += 1
			#if neighbors > 1:
				#return false
	#return true
#
#func get_available_directions(room_pos):
	#var directions = []
	#for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		#var new_pos = room_pos + dir
		#if is_valid_room_position(new_pos):
			#directions.append(dir)
	#return directions
#
#
#
#func create_branch(start_pos: Vector2i, direction: Vector2i, length: int):
	#var current_pos := start_pos
	#var last_room = rooms[start_pos]
	#
	#for i in range(length):
		#current_pos += direction
		#
		#if not is_valid_room_position(current_pos):
			#break
		#
		#layout[current_pos.y][current_pos.x] = RoomType.NORMAL
		#var new_room = {type = RoomType.NORMAL, connections = [current_pos - direction]}
		#rooms[current_pos] = new_room
		#
		#last_room.connections.append(current_pos)
		#last_room = new_room
		#
		## 50% шанс создать боковую ветвь
		#if randf() < 0.5 and i > 0 and rooms.size() < TARGET_ROOM_COUNT:
			#var side_dir = get_perpendicular_direction(direction)			if randf() < 0.5:
				#create_branch(current_pos, -side_dir, 1 + randi() % 2)
#
#func place_boss_room():
	#var end_rooms := []
	#for pos in rooms:
		#if rooms[pos].connections.size() <= 1 and rooms[pos].type == RoomType.NORMAL:
			#end_rooms.append(pos)
	#
	#if end_rooms.is_empty():
		#return
	#
#
#
## функция для вычисления расстояния по пути (количество комнат)
#func get_path_distance(from_pos, to_pos):
	#var visited = {}
	#var queue = []
	#queue.append({pos = from_pos, dist = 0})
	#visited[from_pos] = true
	#
	#while queue.size() > 0:
		#var current = queue.pop_front()
		#
		#if current.pos == to_pos:
			#return current.dist
		#
		#for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			#var neighbor_pos = current.pos + dir
			#if neighbor_pos in rooms and not neighbor_pos in visited:
				#visited[neighbor_pos] = true
				#queue.append({pos = neighbor_pos, dist = current.dist + 1})
	#
	#return -1  # Если путь не найден
#
#
#func initialize_grid():
	#layout = []
	#for y in range(GRID_HEIGHT):
		#layout.append([])
		#for x in range(GRID_WIDTH):
			#layout[y].append(RoomType.EMPTY)
#
	## Находим самую дальнюю комнату по пути от старта
	#var max_dist := -1
	#var farthest_room: Vector2i
	#for pos in end_rooms:
		#var dist = get_path_distance(start_room_pos, pos)
		#if dist > max_dist:
			#max_dist = dist
			#farthest_room = pos
	#
	#layout[farthest_room.y][farthest_room.x] = RoomType.BOSS
	#rooms[farthest_room].type = RoomType.BOSS
	#
	## Удаляем лишние соединения (оставляем только путь от старта)
	#if rooms[farthest_room].connections.size() > 1:
		#var path = find_path_to_start(farthest_room)
		#if not path.is_empty() and path.size() > 1:
			#var correct_connection = path[1]
			#rooms[farthest_room].connections = [correct_connection]
#
#func try_place_secret_rooms():
	#for y in range(1, GRID_HEIGHT-1):
		#for x in range(1, GRID_WIDTH-1):
			#if layout[y][x] != RoomType.EMPTY:
				#continue
				#
			#var adjacent = 0
			#for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				#if layout[y + dir.y][x + dir.x] != RoomType.EMPTY:
					#adjacent += 1
			#
			#if adjacent >= 3 and randf() < 0.3:  # 30% шанс на секретную комнату
				#layout[y][x] = RoomType.SECRET
				#rooms[Vector2i(x, y)] = {type = RoomType.SECRET, connections = []}
#
#func find_path_to_start(end_pos: Vector2i) -> Array:
	#var visited := {}
	#var queue := [[end_pos]]
	#visited[end_pos] = true
	#
	#while not queue.is_empty():
		#var path = queue.pop_front()
		#var current = path[0]
		#
		#if current == start_room_pos:
			#return path
		#
		#for connection in rooms[current].connections:
			#if not connection in visited:
				#visited[connection] = true
				#var new_path = path.duplicate()
				#new_path.push_front(connection)
				#queue.append(new_path)
	#
	#return []
#
## Остальные вспомогательные функции (initialize_grid, get_path_distance, is_valid_room_position и т.д.)
## остаются такими же, как у вас, но с заменой Vector2 на Vector2i где нужно
#
#func build_dungeon():
	#for pos in rooms:
		#var room_data = rooms[pos]
		#var room_scenes = room_scenes_cache[room_data.type]
		#if room_scenes.is_empty():
			#push_error("No rooms available for type: " + str(room_data.type))
			#continue
			#
		#var room_scene = room_scenes.pick_random()
		#var room_instance = room_scene.instantiate()
		#add_child(room_instance)
		#
		## Позиционируем комнату (умножаем на ROOM_SIZE или другой коэффициент)
		#room_instance.position = Vector2(pos.x * ROOM_SIZE * 64, pos.y * ROOM_SIZE * 64)  # Пример для тайлов 64x64
		#
		## Настраиваем двери на основе соединений
		#setup_room_doors(room_instance, pos, room_data.connections)
#
#func setup_room_doors(room_instance: Node, room_pos: Vector2i, connections: Array):
	## Реализация зависит от структуры ваших комнат
	## Примерный код:
	#for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		#var neighbor_pos = room_pos + dir
		#if neighbor_pos in connections:
			## Активируем дверь в этом направлении
			#var door_marker = room_instance.get_node_or_null("DoorMarkers/" + str(dir))
			#if door_marker:
				#var door = preload("res://scenes/door.tscn").instantiate()
				#door_marker.add_child(door)
				#door.target_room = neighbor_pos
				#door.target_position = Vector2(neighbor_pos.x * ROOM_SIZE * 64, neighbor_pos.y * ROOM_SIZE * 64)
#
#func print_layout():
	#var symbols = {
		#RoomType.EMPTY: " ",
		#RoomType.NORMAL: "N",
		#RoomType.START: "S",
		#RoomType.BOSS: "B",
		#RoomType.SECRET: "?"
	#}
	#
	#for y in range(GRID_HEIGHT):
		#var line = ""
		#for x in range(GRID_WIDTH):
			#line += symbols.get(layout[y][x], "?")
		#print(line)
