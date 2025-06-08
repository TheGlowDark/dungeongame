extends Node

var current_dungeon = null
var room_pool = []
var start_room_pool = []
var exit_room_pool = []

const room_root := "res://rooms/normal_rooms/room"
const start_root := "res://rooms/start_rooms/room"
const exit_root := "res://rooms/exit_rooms/room"

signal rooms_loaded  # Сигнал о завершении загрузки
signal level_generated  # Сигнал о завершении генерации

func get_room_path(cur_root, index: int):
	return cur_root + str(index) + ".tscn"
func _ready():
	# Подключаем сигналы
	self.connect("rooms_loaded", Callable(self, "_on_rooms_loaded"))
	
	# Начинаем загрузку
	await load_all_rooms()

func _on_rooms_loaded():
	print("Все комнаты загружены, начинаем генерацию уровня")
	generate_new_level()
	#print("Уровень успешно сгенерирован")
	
	# Активируем игрока
	$Player.active = true
func load_all_rooms() -> void:
	print("Начало загрузки комнат...")
	
	# Загружаем все три типа комнат
	await get_room_array(room_root, room_pool)
	await get_room_array(exit_root, exit_room_pool)
	await get_room_array(start_root, start_room_pool)
	
	# Проверяем загрузку
	if room_pool.is_empty() or start_room_pool.is_empty() or exit_room_pool.is_empty():
		push_error("Не все комнаты загружены!")
		return
	
	emit_signal("rooms_loaded")  # Отправляем сигнал о завершении

func get_room_array(root: String, pool: Array) -> bool:
	print("Загрузка комнат из: ", root)
	
	var i = 1
	var loaded_count = 0
	
	while true:
		# Формируем путь к файлу
		var room_path = "%s%d.tscn" % [root, i]
		
		# Проверяем существование файла
		if not ResourceLoader.exists(room_path):
			print("Файл не найден: ", room_path)
			break
			
		# Асинхронная загрузка с проверкой
		var load_state = ResourceLoader.load_threaded_request(room_path)
		
		# Ждем завершения загрузки
		while true:
			var progress = []
			var status = ResourceLoader.load_threaded_get_status(room_path, progress)
			
			match status:
				ResourceLoader.THREAD_LOAD_LOADED:
					var room_scene = ResourceLoader.load_threaded_get(room_path)
					if room_scene:
						pool.append(room_scene)
						loaded_count += 1
						print("Успешно загружена комната: ", room_path)
					else:
						push_error("Ошибка загрузки: ", room_path)
					break
					
				ResourceLoader.THREAD_LOAD_FAILED:
					push_error("Не удалось загрузить: ", room_path)
					break
					
				ResourceLoader.THREAD_LOAD_IN_PROGRESS:
					await get_tree().process_frame
		
		i += 1
		#await get_tree().process_frame  # Даем время на обработку
	
	print("Загружено комнат: ", loaded_count, " из ", root)
	
	if loaded_count == 0:
		push_error("Не загружено ни одной комнаты из: ", root)
		return false
	
	return true

func getbasicroom():
	if room_pool.is_empty():
		push_error("Пул обычных комнат пуст!")
		return null
	return room_pool[randi() % room_pool.size()]
	
func getstartroom():
	if start_room_pool.is_empty():
		push_error("Пул стартовых комнат пуст!")
		return null
	return start_room_pool[0]  # Всегда используем первую стартовую комнату

func getexitroom():
	if exit_room_pool.is_empty():
		push_error("Пул выходных комнат пуст!")
		return null
	return exit_room_pool[randi() % exit_room_pool.size()]

func generate_new_level():
	if(Global.current_level != 1):
		Global.floor_up()
	print("Начало генерации уровня...")
	
	if current_dungeon:
		current_dungeon.queue_free()
	
	current_dungeon = preload("res://scenes/level.tscn").instantiate()
	add_child(current_dungeon)
	
	# Ждем завершения генерации в дочернем уровне
	await current_dungeon.generate()
	
	emit_signal("level_generated")  # Отправляем сигнал о завершении
