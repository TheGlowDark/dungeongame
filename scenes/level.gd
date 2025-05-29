extends Node

const GRID_WIDTH = 13  # Нечетное для симметрии
const GRID_HEIGHT = 13
const ROOM_SIZE = 11    # Размер комнаты в тайлах (нечетное)
const TILE_SIZE := 32  # Размер одного тайла в пикселях
const ROOM_SIZE_PIXELS := ROOM_SIZE * TILE_SIZE  # Общий размер комнаты в пикселях

const map_root = "res://rooms/normal_rooms/room"
func get_room_path(index):
	return map_root + str(index) + ".tscn"

const map_number = 1

const TARGET_ROOM_COUNT = 15  # Фиксированное количество комнат
const MIN_BOSS_DISTANCE = 6   # Минимальное расстояние от старта до босса

enum RoomType {EMPTY, NORMAL, START, BOSS, SECRET}

var layout = []        # 2D массив типов комнат
var rooms = {}         # Словарь позиций и данных комнат
var room_pool = []

var start_position = Vector2(ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2,ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2)
var start_room_pos = Vector2(6, 6)  # Центральная позиция

func _ready():
#	arrow_texture()
	$Camera2D.start()
	randomize()
	generate_paths()
	print_layout()
	get_room_array()
	build_dungeon()
	layout[start_room_pos.x][start_room_pos.y] *= -1
	
	print(rooms)
	$Player.position = start_position
	$Camera2D.position = start_position

func build_dungeon():
	for j in range(GRID_WIDTH):
		for i in range(GRID_HEIGHT):
			#Если в массиве 1, то рисеум комнату
			if layout[i][j] != RoomType.EMPTY:
				draw_room(i, j)


func draw_room(y, x):
	var s = room_pool[randi_range(0, room_pool.size()-1)].instantiate()
	s.room_position = Vector2(y, x)
	s.position = Vector2(x * ROOM_SIZE_PIXELS, y * ROOM_SIZE_PIXELS)
#wa	if layout[x][y] == RoomType.START:
#		s.enter()
	#var room = get_room_path(randi_range(0, map_number)).instantiate()
	add_child(s) 
	#наверх направо вниз налево
	add_one_door(y - 1,x, ROOM_SIZE_PIXELS / 2, ROOM_SIZE_PIXELS - TILE_SIZE * 2, s, 0) #телепорт направо это середина от отсчета комнаты + 1 тайл (стены)
	add_one_door(y, x + 1, TILE_SIZE * 2, ROOM_SIZE_PIXELS / 2, s,1) 
	add_one_door(y + 1, x, ROOM_SIZE_PIXELS / 2, TILE_SIZE * 2,s,2)
	add_one_door(y,x - 1,ROOM_SIZE_PIXELS - TILE_SIZE * 2, ROOM_SIZE_PIXELS / 2,s,3)
	

func add_one_door(y, x, add_x, add_y,s,n):
	#Делаем сложную проверку:
	#Проверяем не выходят ли переменные, за границы
	#Проверяем есть ли уже комнаты
	#Не путайте с условием из add_one_room - ЭТО ДРУГОЕ
	if ((x >= 0) && (x < GRID_WIDTH) && (y >= 0) && (y < GRID_HEIGHT) && (layout[y][x] != RoomType.EMPTY)):
		var d = preload("res://scenes/door.tscn").instantiate()
		d.transform = s.get_child(n).transform
		d.side = n
		#Задали положение для телепорта
		#Умножаем на размер комнаты
		d.set_next_pos(Vector2(x*ROOM_SIZE_PIXELS+add_x,y*ROOM_SIZE_PIXELS+add_y))
		s.add_child(d)
	
	


func get_room_array():
	#Счётчик
	var i = 1
	while true:
		#Если такая сцена есть, то добавляем в массив
		if load(get_room_path(i)) != null:
			room_pool.append(load(get_room_path(i)))
		#Иначе заканчиваем while
		#У меня все комнаты идут по порядку(Room1,Room2...)
		#Можно сделать чуть иначе, но так проще...
		else:
			break
		i+=1


#func build_dungeon():
	#for k in rooms:
		#draw_room(k[0])
	#


	
#func arrow_texture():
	#var game_scale = get_viewport().get_camera_2d().zoom.x  # или .y, если масштаб неодинаковый
	#custom_cursor.texture = preload("res://assets/textures/cursor/cursor.png")
	#custom_cursor.scale = Vector2(game_scale, game_scale)
	#add_child(custom_cursor)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Скрываем системный курсор
	#custom_cursor.z_index = 100
	#
func generate_paths():
	initialize_grid()
	
	# создание начальной комнаты
	layout[start_room_pos.x][start_room_pos.y] = RoomType.START
	rooms[start_room_pos] = {type = RoomType.START, connections = []}
	
	# генерация ветвлений пока не достигнем нужного количества комнат
	var attempts = 0
	while rooms.size() < TARGET_ROOM_COUNT and attempts < 100:
		# Выбираем случайную комнату для ветвления
		var existing_rooms = rooms.keys()
		var random_room_pos = existing_rooms[randi() % existing_rooms.size()]
		
		# Создаем несколько ветвей из этой комнаты
		var directions = get_available_directions(random_room_pos)
		directions.shuffle()
		
		for dir in directions:
			if rooms.size() >= TARGET_ROOM_COUNT:
				break
			create_branch(random_room_pos, dir, 1 + randi() % 3)  # Короткие ветви
		attempts += 1
	
	# если не хватило комнат, добавляем еще
	if rooms.size() < TARGET_ROOM_COUNT:
		add_missing_rooms()
	
	# добавление комнаты босса (должна быть конечной и на нужном расстоянии)
	place_boss_room()
	
	# добавление секретных комнат
#	try_place_secret_rooms()


func initialize_grid():
	layout = []
	for y in range(GRID_HEIGHT):
		layout.append([])
		for x in range(GRID_WIDTH):
			layout[y].append(RoomType.EMPTY)

func create_branch(start_pos, direction, length):
	var current_pos = start_pos
	var last_room = rooms[start_pos]
	
	for i in range(length):
		current_pos += direction
		
		# проверяем границы и пересечения
		if not is_valid_room_position(current_pos):
			break
		
		# создаем комнату
		layout[current_pos.x][current_pos.y] = RoomType.NORMAL
		var new_room = {type = RoomType.NORMAL, connections = [current_pos - direction]}
		rooms[current_pos] = new_room
		
		# добавляем соединение в предыдущую комнату
		last_room.connections.append(current_pos)
		last_room = new_room
		
		# 50% шанс создать боковую ветвь
		if randf() < 0.5 and i > 0 and rooms.size() < TARGET_ROOM_COUNT:
			var side_dir = get_perpendicular_direction(direction)
			if randf() < 0.5:  # 50% шанс создать вторую боковую ветвь
				var side_dir2 = -side_dir
				create_branch(current_pos, side_dir2, 1 + randi() % 2)

func place_boss_room():
	# находим все конечные комнаты (без дальнейших соединений)
	var end_rooms = []
	for pos in rooms:
		if rooms[pos].connections.size() == 0 or (rooms[pos].connections.size() == 1 and rooms[pos].type == RoomType.NORMAL):
			end_rooms.append(pos)
	
	if end_rooms.size() == 0:
		return
	
	var candidate_rooms = []
	#for pos in end_rooms:
		#var dist = get_path_distance(start_room_pos, pos)
		#if dist >= MIN_BOSS_DISTANCE:
			#candidate_rooms.append(pos)
	#
	# если нет комнат на нужном расстоянии, берем самую дальнюю
	#if candidate_rooms.size() == 0:
	var max_dist = -1
	var farthest_room = null
	for pos in end_rooms:
		var dist = get_path_distance(start_room_pos, pos)
		if dist > max_dist:
			max_dist = dist
			farthest_room = pos
	if farthest_room:
		candidate_rooms.append(farthest_room)
	
	# выбираем случайную комнату из кандидатов
	if candidate_rooms.size() > 0:
		var boss_pos = candidate_rooms[randi() % candidate_rooms.size()]
		layout[boss_pos.x][boss_pos.y] = RoomType.BOSS
		rooms[boss_pos].type = RoomType.BOSS
		
		# убедимся, что это конечная комната (удаляем все соединения кроме одного)
		if rooms[boss_pos].connections.size() > 1:
			# Оставляем только первое соединение
			var main_connection = rooms[boss_pos].connections[0]
			rooms[boss_pos].connections = [main_connection]

# функция для вычисления расстояния по пути (количество комнат)
func get_path_distance(from_pos, to_pos):
	var visited = {}
	var queue = []
	queue.append({pos = from_pos, dist = 0})
	visited[from_pos] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current.pos == to_pos:
			return current.dist
		
		for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			var neighbor_pos = current.pos + dir
			if neighbor_pos in rooms and not neighbor_pos in visited:
				visited[neighbor_pos] = true
				queue.append({pos = neighbor_pos, dist = current.dist + 1})
	
	return -1  # Если путь не найден

#func try_place_secret_rooms():
	# ищем места, окруженные 3+ комнатами, но не занятые
	#for y in range(1, GRID_HEIGHT-1):
		#for x in range(1, GRID_WIDTH-1):
			#if layout[y][x] != RoomType.EMPTY:
				#continue
				#
			#var adjacent = 0
			#for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
				#if layout[y + dir.y][x + dir.x] != RoomType.EMPTY:
					#adjacent += 1
			#
			#if adjacent >= 3 and randf() < 0.5:
				#layout[y][x] = RoomType.SECRET
				#rooms[Vector2(x, y)] = {type = RoomType.SECRET, connections = []}

func is_valid_room_position(pos):
	if pos.y < 0 or pos.x < 0 or pos.y >= GRID_WIDTH or pos.x >= GRID_HEIGHT:
		return false
	if layout[pos.x][pos.y] != RoomType.EMPTY:
		return false
	
	# Проверяем, чтобы не было соседей кроме предыдущей комнаты
	var neighbors = 0
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var check_pos = pos + dir
		if check_pos.y < 0 or check_pos.x < 0 or check_pos.y >= GRID_WIDTH or check_pos.x >= GRID_HEIGHT:
			continue
		if layout[check_pos.x][check_pos.y] != RoomType.EMPTY:
			neighbors += 1
			if neighbors > 1:
				return false
	return true

func get_perpendicular_direction(dir):
	if dir.x != 0:
		return Vector2(0, 1 if randf() < 0.5 else -1)
	else:
		return Vector2(1 if randf() < 0.5 else -1, 0)

func find_furthest_room(from_pos, room_list):
	var max_dist = -1
	if room_list.size() == 0:
		return null
	var result = null
	
	for pos in room_list:
		var dist = pos.distance_to(from_pos)
		if dist > max_dist:
			max_dist = dist
			result = pos
	return result

func get_available_directions(room_pos):
	var directions = []
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var new_pos = room_pos + dir
		if is_valid_room_position(new_pos):
			directions.append(dir)
	return directions

func add_missing_rooms():
	# добавляем недостающие комнаты, создавая новые ветви
	while rooms.size() < TARGET_ROOM_COUNT:
		var existing_rooms = rooms.keys()
		var random_room_pos = existing_rooms[randi() % existing_rooms.size()]
		
		var directions = get_available_directions(random_room_pos)
		if directions.size() > 0:
			directions.shuffle()
			create_branch(random_room_pos, directions[0], 1)
		else:
			# если нет доступных направлений, прерываем цикл
			break

func print_layout():
	var symbols = {
		RoomType.EMPTY: " ",
		RoomType.NORMAL: "N",
		RoomType.START: "S",
		RoomType.BOSS: "B",
		RoomType.SECRET: "?"
	}
	
	for y in range(GRID_HEIGHT):
		var line = ""
		for x in range(GRID_WIDTH):
			line += symbols[layout[y][x]]
		print(line)
