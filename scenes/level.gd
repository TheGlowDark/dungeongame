extends Node

const GRID_WIDTH = 13  # Нечетное для симметрии
const GRID_HEIGHT = 13
const ROOM_SIZE = 11    # Размер комнаты в тайлах (нечетное)
const TILE_SIZE := 32  # Размер одного тайла в пикселях
const ROOM_SIZE_PIXELS := ROOM_SIZE * TILE_SIZE  # Общий размер комнаты в пикселях

#const room_root := "res://rooms/normal_rooms/room"
#const start_root := "res://rooms/start_rooms/room"
#const exit_root := "res://rooms/exit_rooms/room"

#func get_room_path(cur_root, index: int):
	#return cur_root + str(index) + ".tscn"

const map_number = 1

@export var TARGET_ROOM_COUNT = 5  # Фиксированное количество комнат
#const MIN_BOSS_DISTANCE = 6   # Минимальное расстояние от старта до босса

enum RoomType {EMPTY, NORMAL, START, BOSS, SECRET}

var layout         # 2D массив типов комнат
var rooms         # Словарь позиций и данных комнат
var room_pool 
var start_room_pool
var exit_room_pool 

var start_position = Vector2(ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2,ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2)
var start_room_pos = Vector2(6, 6)  # Центральная позиция
var exit_room : Vector2

@onready var map = $"../Player/UI/map"
@onready var player = get_tree().get_nodes_in_group("player")[0]
func _ready():
	rooms = {}
	$Camera2D.position = start_position
	player.position = start_position
	TARGET_ROOM_COUNT += Global.Room_add
#	arrow_texture()
	start_room_pool = get_parent().start_room_pool
	room_pool = get_parent().room_pool
	exit_room_pool = get_parent().exit_room_pool
	$Camera2D.start()
	randomize()
	generate_paths()
	print_layout()
	build_dungeon()
	map.initializate(layout)
	#layout[start_room_pos.x][start_room_pos.y] *= -1
	#print(rooms)
	#$Player.position = start_position
	player.active = true

func build_dungeon():
	for j in range(GRID_WIDTH):
		for i in range(GRID_HEIGHT):
			#Если в массиве 1, то рисеум комнату
			if layout[i][j] != RoomType.EMPTY:
				draw_room(i, j)


func draw_room(y, x):
	var s
	if Vector2(y, x) == start_room_pos:
		s = start_room_pool[0].instantiate()
	elif Vector2(y, x) == exit_room:
		s = exit_room_pool[randi_range(0, exit_room_pool.size()-1)].instantiate()
	else:
		s = room_pool[randi_range(0, room_pool.size()-1)].instantiate()
	s.room_position = Vector2(y, x)
	s.position = Vector2(x * ROOM_SIZE_PIXELS, y * ROOM_SIZE_PIXELS)
#wa	if layout[x][y] == RoomType.START:
#		s.enter()
	#var room = get_room_path(randi_range(0, map_number)).instantiate()
	call_deferred("add_child", s) 
	#наверх направо вниз налево
	add_one_door(y - 1,x, ROOM_SIZE_PIXELS / 2, ROOM_SIZE_PIXELS - TILE_SIZE - 4, s, 0) #телепорт направо это середина от отсчета комнаты + 1 тайл (стены)
	add_one_door(y, x + 1, TILE_SIZE + 12, ROOM_SIZE_PIXELS / 2, s,1) 
	add_one_door(y + 1, x, ROOM_SIZE_PIXELS / 2, TILE_SIZE + 8,s,2)
	add_one_door(y,x - 1,ROOM_SIZE_PIXELS - TILE_SIZE - 12, ROOM_SIZE_PIXELS / 2,s,3)
	

func add_one_door(y, x, add_x, add_y,s,n):
	#Делаем сложную проверку:
	#Проверяем не выходят ли переменные, за границы
	#Проверяем есть ли уже комнаты
	#Не путайте с условием из add_one_room - ЭТО ДРУГОЕ
	if ((x >= 0) && (x < GRID_WIDTH) && (y >= 0) && (y < GRID_HEIGHT) && (layout[y][x] != RoomType.EMPTY)):
		var d = preload("res://scenes/door.tscn").instantiate()
#		d.frame = n
		d.transform = s.get_child(n).transform
#		d.door_rotate(n)
		#Задали положение для телепорта
		#Умножаем на размер комнаты
		s.get_node("doors").call_deferred("add_child", d)
		d.set_next_pos(Vector2(x*ROOM_SIZE_PIXELS+add_x,y*ROOM_SIZE_PIXELS+add_y), n, Vector2(y, x))
	
	



func initialize_grid():
	layout = []
	for y in range(GRID_HEIGHT):
		layout.append([])
		for x in range(GRID_WIDTH):
			layout[y].append(RoomType.EMPTY)


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

	return true
func generate_paths():
	initialize_grid()
	
	# Создаем стартовую комнату
	layout[start_room_pos.x][start_room_pos.y] = RoomType.START
	rooms[start_room_pos] = {type = RoomType.START, connections = []}
	
	# Список возможных направлений
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	# Генерируем комнаты пока не достигнем нужного количества
	var attempts = 0
	while rooms.size() < TARGET_ROOM_COUNT and attempts < 200:
		# Выбираем случайную существующую комнату
		var existing_rooms = rooms.keys()
		var random_room_pos = existing_rooms[randi() % existing_rooms.size()]
		
		# Выбираем случайное направление
		var dir = directions[randi() % directions.size()]
		var new_pos = random_room_pos + dir
		
		# Проверяем можно ли разместить комнату
		if is_valid_room_position(new_pos):
			layout[new_pos.x][new_pos.y] = RoomType.NORMAL
			rooms[new_pos] = {type = RoomType.NORMAL, connections = [random_room_pos]}
			rooms[random_room_pos].connections.append(new_pos)
		
		attempts += 1
	
	# Помещаем босса в самую дальнюю комнату
	place_furthest_boss_room()

func is_valid_room_position(pos):
	# Проверяем границы
	if pos.x < 0 or pos.y < 0 or pos.x >= GRID_WIDTH or pos.y >= GRID_HEIGHT:
		return false
	
	# Проверяем что клетка пуста
	if layout[pos.x][pos.y] != RoomType.EMPTY:
		return false
	
	# Проверяем что у новой комнаты будет только 1 сосед (та, от которой она создается)
	var neighbors = 0
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var check_pos = pos + dir
		if check_pos in rooms:
			neighbors += 1
			if neighbors > 1:
				return false
				
	return true

func get_available_directions(room_pos):
	var directions = []
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var new_pos = room_pos + dir
		if is_valid_room_position(new_pos):
			directions.append(dir)
	return directions

func place_furthest_boss_room():
	var furthest_room = null
	var max_distance = 0
	
	# Ищем комнату с максимальным расстоянием от старта
	for room_pos in rooms:
		if room_pos == start_room_pos:
			continue
			
		var dist = start_room_pos.distance_to(room_pos)
		if dist > max_distance:
			max_distance = dist
			furthest_room = room_pos
	
	if furthest_room:
		layout[furthest_room.x][furthest_room.y] = RoomType.BOSS
		rooms[furthest_room].type = RoomType.BOSS
		exit_room = furthest_room

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
