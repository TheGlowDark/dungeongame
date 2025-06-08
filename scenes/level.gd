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
#const MIN_EXIT_DISTANCE = 6   # Минимальное расстояние от старта до босса

enum RoomType {EMPTY, NORMAL, START, EXIT}

var layout         # 2D массив типов комнат
var rooms         # Словарь позиций и данных комнат
var cur_room_pool 
var cur_start_room_pool
var cur_exit_room_pool 
var statistic = []
var start_position = Vector2(ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2,ROOM_SIZE_PIXELS * round(GRID_WIDTH/2) + ROOM_SIZE_PIXELS / 2)
var start_room_pos = Vector2(6, 6)  # Центральная позиция
var exit_room : Vector2

@onready var map = $"../Player/UI/map"
@onready var player = get_tree().get_nodes_in_group("player")[0]
func _ready():
	rooms = {}
	TARGET_ROOM_COUNT += Global.room_add
#	arrow_texture()
	randomize()
	#$Camera2D.position = start_position
	player.position = start_position
	$Camera2D.start()
	statistic = []
	#run_tests()
	#test_room_number()
	#generate_paths()
	#print_layout()
	#build_dungeon()
	#map.initializate(layout)
	#layout[start_room_pos.x][start_room_pos.y] *= -1
	#print(rooms)
	#$Player.position = start_position
	player.active = true
	
	
func run_tests():
	print("Запуск тестов...")
	for i in range(1000):
		layout = []
		rooms = {}
		test_initialize_grid()
		test_grid_boundaries()
		test_position_validation()
		test_grid_after_generation()
	print("Все тесты пройдены успешно!")
	
func test_grid_after_generation():
	# Генерируем уровень
	generate_paths()
	
	# Проверяем стартовую комнату
	assert(layout[start_room_pos.x][start_room_pos.y] == RoomType.START, 
		   "Стартовая комната должна быть в позиции " + str(start_room_pos))
	
	# Проверяем комнату босса
	var has_EXIT = false
	for x in range(GRID_HEIGHT):
		for y in range(GRID_WIDTH):
			if layout[x][y] == RoomType.EXIT:
				has_EXIT = true
#				assert(Vector2(y,x) == exit_room, "Позиция босса должна совпадать с exit_room")
	assert(has_EXIT, "Должна быть хотя бы одна комната выхода")
	
	# Проверяем количество комнат
	var room_count = 0
	for row in layout:
		for cell in row:
			if cell != RoomType.EMPTY:
				room_count += 1
	assert(room_count == TARGET_ROOM_COUNT, 
		   "Количество комнат должно быть " + str(TARGET_ROOM_COUNT) + ", а получилось " + str(room_count))
	
	print("Тест grid_after_generation() пройден успешно")


func test_initialize_grid():
	# Вызываем инициализацию
	initialize_grid()
	
	# Проверяем размеры сетки
	assert(layout.size() == GRID_HEIGHT, "Высота сетки должна быть " + str(GRID_HEIGHT))
	for row in layout:
		assert(row.size() == GRID_WIDTH, "Ширина каждой строки должна быть " + str(GRID_WIDTH))
		
		# Проверяем, что все ячейки пустые
		for cell in row:
			assert(cell == RoomType.EMPTY, "Все ячейки должны быть EMPTY после инициализации")
	
	print("Тест initialize_grid() пройден успешно")

func test_grid_boundaries():
	initialize_grid()
	
	# Проверяем доступ к граничным ячейкам
	assert(layout[0][0] == RoomType.EMPTY, "Левый верхний угол должен быть доступен")
	assert(layout[0][GRID_WIDTH-1] == RoomType.EMPTY, "Правый верхний угол должен быть доступен")
	assert(layout[GRID_HEIGHT-1][0] == RoomType.EMPTY, "Левый нижний угол должен быть доступен")
	assert(layout[GRID_HEIGHT-1][GRID_WIDTH-1] == RoomType.EMPTY, "Правый нижний угол должен быть доступен")
	
	print("Тест grid_boundaries() пройден успешно")

	
func test_position_validation():
	initialize_grid()
	
	# Проверяем валидные позиции
	assert(is_valid_room_position(Vector2(1,1)), "Центральная позиция должна быть валидной")
	
	# Проверяем невалидные позиции
	assert(!is_valid_room_position(Vector2(-1,0)), "Отрицательные координаты недопустимы")
	assert(!is_valid_room_position(Vector2(GRID_WIDTH,0)), "Координаты за пределами сетки недопустимы")
	
	# Проверяем занятые позиции
	layout[3][3] = RoomType.NORMAL
	assert(!is_valid_room_position(Vector2(3,3)), "Занятая позиция не должна быть валидной")
	
	print("Тест position_validation() пройден успешно")
	
func generate():
	#run_tests()
	#TARGET_ROOM_COUNT += Global.Room_add
	print("Генерация структуры уровня...")
	initialize_pools()
	generate_paths()
	print_layout()
	build_dungeon()
	map.initializate(layout)
	player.update_floor()
	print(layout)
	
func initialize_pools():
	cur_start_room_pool = get_parent().start_room_pool.duplicate()
	cur_room_pool = get_parent().room_pool.duplicate()
	cur_exit_room_pool = get_parent().exit_room_pool.duplicate()
	
func test_room_number():
	var count_correct = 0
	for i in range(1000):
		run_tests()
		rooms = {}
		layout = []
		randomize()
		initialize_grid()
		generate_paths()
		if (rooms.size() == TARGET_ROOM_COUNT):
			count_correct += 1
	if(count_correct == 1000):
		print("Ошибок не обнаружено")
	
	
func build_dungeon():
	#for j in range(GRID_WIDTH):
		#for i in range(GRID_HEIGHT):
			##Если в массиве 1, то рисеум комнату
			#if layout[i][j] != RoomType.EMPTY:
	for r in rooms:
		draw_room(r[0], r[1])


func draw_room(y, x):
	var s
	if Vector2(y, x) == start_room_pos:
		s = cur_start_room_pool[0].instantiate()
		cur_start_room_pool.remove_at(0) 
	elif Vector2(y, x) == exit_room:
		var index = randi_range(0, cur_exit_room_pool.size()-1)
		s = cur_exit_room_pool[index].instantiate()
		cur_exit_room_pool.remove_at(index) 
	else:
		s = cur_room_pool[randi_range(0, cur_room_pool.size()-1)].instantiate()
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

#func generate_paths():
	#initialize_grid()
	#
	## Создаем стартовую комнату
	#layout[start_room_pos.x][start_room_pos.y] = RoomType.START
	#rooms[start_room_pos] = {type = RoomType.START, connections = []}
	#
	## Очередь для BFS и множество посещенных позиций
	#var queue = [start_room_pos]
	#var visited = {start_room_pos: true}
	#var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	#
	## Генерируем комнаты пока не достигнем нужного количества
	#while rooms.size() < TARGET_ROOM_COUNT and not queue.is_empty():
		## Берем первую позицию из очереди
		#var current_pos = queue.pop_front()
		#
		## Перемешиваем направления для случайности
		#directions.shuffle()
		#var num_directions = randi() % 4 + 1  # Случайное число от 1 до 4
		## Пробуем добавить комнаты во всех направлениях
		#for i in range(num_directions):
			#var new_pos = current_pos + directions[i]
			#
			## Если позиция валидна и еще не посещена
			#if is_valid_room_position(new_pos) and not visited.has(new_pos):
				#layout[new_pos.x][new_pos.y] = RoomType.NORMAL
				#rooms[new_pos] = {type = RoomType.NORMAL, connections = [current_pos]}
				#rooms[current_pos].connections.append(new_pos)
				#queue.append(new_pos)
				#visited[new_pos] = true
				#
				## Прекращаем если достигли цели
				#if rooms.size() >= TARGET_ROOM_COUNT:
					#break
func generate_paths():
	initialize_grid()
	
	# Создаем стартовую комнату
	layout[start_room_pos.x][start_room_pos.y] = RoomType.START
	rooms[start_room_pos] = {
		type = RoomType.START, 
		connections = [],
		distance = 0  # Расстояние от старта
	}
	
	var queue = [start_room_pos]
	var visited = {start_room_pos: true}
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	# Переменные для отслеживания самой дальней комнаты
	var furthest_room = null
	var max_distance = 0
	
	while rooms.size() < TARGET_ROOM_COUNT and not queue.is_empty():
		var current_pos = queue.pop_front()
		var current_dist = rooms[current_pos].distance
		
		directions.shuffle()
		var num_directions = min(4, TARGET_ROOM_COUNT - rooms.size())
		if num_directions > 0:
			num_directions = randi() % num_directions + 1
			
			for i in range(num_directions):
				var new_pos = current_pos + directions[i]
				
				if is_valid_room_position(new_pos) and not visited.has(new_pos):
					# Добавляем комнату с расстоянием на 1 больше текущего
					var new_dist = current_dist + 1
					layout[new_pos.x][new_pos.y] = RoomType.NORMAL
					rooms[new_pos] = {
						type = RoomType.NORMAL,
						connections = [current_pos],
						distance = new_dist
					}
					rooms[current_pos].connections.append(new_pos)
					queue.append(new_pos)
					visited[new_pos] = true
					
					# Обновляем самую дальнюю комнату
					if new_dist > max_distance:
						max_distance = new_dist
						furthest_room = new_pos
					
					if rooms.size() >= TARGET_ROOM_COUNT:
						break
	
	# Добавляем недостающие комнаты (если BFS не смог добавить все)
	while rooms.size() < TARGET_ROOM_COUNT:
		var existing_rooms = rooms.keys()
		var random_room_pos = existing_rooms[randi() % existing_rooms.size()]
		var current_dist = rooms[random_room_pos].distance
		
		directions.shuffle()
		for dir in directions:
			var new_pos = random_room_pos + dir
			if is_valid_room_position(new_pos) and not rooms.has(new_pos):
				var new_dist = current_dist + 1
				layout[new_pos.x][new_pos.y] = RoomType.NORMAL
				rooms[new_pos] = {
					type = RoomType.NORMAL,
					connections = [random_room_pos],
					distance = new_dist
				}
				rooms[random_room_pos].connections.append(new_pos)
				
				# Обновляем самую дальнюю комнату
				if new_dist > max_distance:
					max_distance = new_dist
					furthest_room = new_pos
				break
	
	# Назначаем самую дальнюю комнату как комнату босса
	if furthest_room:
		layout[furthest_room.x][furthest_room.y] = RoomType.EXIT
		rooms[furthest_room].type = RoomType.EXIT
		exit_room = furthest_room
	
#func generate_paths():
	#initialize_grid()
	#
	## Создаем стартовую комнату
	#layout[start_room_pos.x][start_room_pos.y] = RoomType.START
	#rooms[start_room_pos] = {type = RoomType.START, connections = []}
	#
	## Список возможных направлений
	#var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	#
	## Генерируем комнаты пока не достигнем нужного количества
	#var attempts = 0
	#while rooms.size() < TARGET_ROOM_COUNT and attempts < 200:
		## Выбираем случайную существующую комнату
		#var existing_rooms = rooms.keys()
		#var random_room_pos = existing_rooms[randi() % existing_rooms.size()]
		#
		## Выбираем случайное направление
		#var dir = directions[randi() % directions.size()]
		#var new_pos = random_room_pos + dir
		#
		## Проверяем можно ли разместить комнату
		#if is_valid_room_position(new_pos):
			#layout[new_pos.x][new_pos.y] = RoomType.NORMAL
			#rooms[new_pos] = {type = RoomType.NORMAL, connections = [random_room_pos]}
			#rooms[random_room_pos].connections.append(new_pos)
		#
		#attempts += 1
	#
	## Помещаем босса в самую дальнюю комнату
	#place_furthest_EXIT_room()

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

func place_furthest_EXIT_room():
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
		layout[furthest_room.x][furthest_room.y] = RoomType.EXIT
		rooms[furthest_room].type = RoomType.EXIT
		exit_room = furthest_room
		
	# Возвращаем управление после завершения
	await get_tree().process_frame
func print_layout():
	var symbols = {
		RoomType.EMPTY: " ",
		RoomType.NORMAL: "N",
		RoomType.START: "S",
		RoomType.EXIT: "B",
	}
	
	for y in range(GRID_HEIGHT):
		var line = ""
		for x in range(GRID_WIDTH):
			line += symbols[layout[y][x]]
		print(line)
