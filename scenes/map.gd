extends GridContainer

# Настройки матрицы
@export var grid_size := Vector2.ZERO
@export var cell_size := Vector2(5, 5)
@export var unvisited := Color.GRAY
@export var visited := Color.YELLOW
@export var current := Color.ORANGE
@export var clear := Color.TRANSPARENT
var first_room: Vector2
var matrix = []
var cur_pivot = Vector2.ZERO
var layout

func _ready():
#	add_theme_constant_override("hseparation", 0)  # Горизонтальный промежуток
#	add_theme_constant_override("vseparation", 0)  # Вертикальный промежуток
	add_theme_constant_override("hseparation", 0)  # Горизонтальные отступы
	add_theme_constant_override("vseparation", 0)  # Вертикальные отступы

func initializate(l):
	
	clear_matrix()
	var level = get_tree().root.get_child(4).get_child(2)
	layout = l
	grid_size.x = level.GRID_WIDTH
	grid_size.y = level.GRID_HEIGHT
	first_room = level.start_room_pos
	# Настройка контейнера
	columns = grid_size.x
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	# Создаем матрицу
	create_matrix()
	update(first_room)
	#reveal_map()
	# Тестовая окраска
	#set_cell_color(Vector2(2, 3), Color.red)


func reveal_map():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			if layout[y][x] != 0:
				matrix[y][x].color = unvisited
	matrix[first_room.x][first_room.y].color = current
	
func create_matrix():
	for y in range(grid_size.y):
		var row = []
		for x in range(grid_size.x):
			var cell = ColorRect.new()
			cell.color = clear
			cell.custom_minimum_size = cell_size
			add_child(cell)
			row.append(cell)
		matrix.append(row)
	


# Изменить цвет конкретной ячейки
func update(pos: Vector2):
	if is_valid_position(pos):
		if(cur_pivot != Vector2.ZERO):
			matrix[cur_pivot.x][cur_pivot.y].color = visited
		cur_pivot = pos
#		matrix[pos.y][pos.x].visible = true
		matrix[pos.x][pos.y].color = current
		check_neighbours(pos)

# Проверка на валидность позиции
func is_valid_position(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < grid_size.x and pos.y < grid_size.y

func check_neighbours(pos: Vector2):
	var x = pos.x
	var y = pos.y
	if(is_valid_position(pos + Vector2(1, 0)) and layout[x + 1][y] != 0 and matrix[x + 1][y].color == clear):
		matrix[x + 1][y].color = unvisited
	if(is_valid_position(pos + Vector2(-1, 0)) and layout[x - 1][y] != 0 and matrix[x - 1][y].color == clear):
		matrix[x - 1][y].color = unvisited
	if(is_valid_position(pos + Vector2(0, 1)) and layout[x][y + 1] != 0 and matrix[x][y + 1].color == clear):
		matrix[x][y + 1].color = unvisited
	if(is_valid_position(pos + Vector2(0, -1)) and layout[x][y - 1] != 0 and matrix[x][y - 1].color == clear):
		matrix[x][y - 1].color = unvisited


# Очистить всю матрицу (вернуть к цвету по умолчанию)
func clear_matrix():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			matrix[x][y].color = clear
	cur_pivot = Vector2.ZERO
