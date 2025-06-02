extends GridContainer

# Настройки матрицы
@export var grid_size := Vector2(10, 10)
@export var cell_size := Vector2(3, 3)
@export var default_color := Color(0.8, 0.8, 0.8)
var first_room: Vector2
var matrix = []

func _ready():
#	add_theme_constant_override("hseparation", 0)  # Горизонтальный промежуток
#	add_theme_constant_override("vseparation", 0)  # Вертикальный промежуток
	add_theme_constant_override("hseparation", 0)  # Горизонтальные отступы
	add_theme_constant_override("vseparation", 0)  # Вертикальные отступы

func initializate():
	var level = get_parent().get_parent().get_child(0)
	matrix = level.layout
	first_room = level.start_room_pos
	# Настройка контейнера
	columns = grid_size.x
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	# Создаем матрицу
	create_matrix()
	update(first_room, default_color)
	# Тестовая окраска
	#set_cell_color(Vector2(2, 3), Color.red)

func create_matrix():
	for y in range(grid_size.y):
		var row = []
		for x in range(grid_size.x):
			var cell = ColorRect.new()
			cell.color = Color.TRANSPARENT
			cell.custom_minimum_size = cell_size
			add_child(cell)
			row.append(cell)
		matrix.append(row)


# Изменить цвет конкретной ячейки
func update(pos: Vector2, color: Color):
	if is_valid_position(pos):
		matrix[pos.y][pos.x].visible = true
		matrix[pos.y][pos.x].color = default_color

# Проверка на валидность позиции
func is_valid_position(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < grid_size.x and pos.y < grid_size.y

# Очистить всю матрицу (вернуть к цвету по умолчанию)
func clear_matrix():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			matrix[y][x].color = default_color
