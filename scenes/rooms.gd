extends Node2D

@export var room_data: Dictionary # Данные о расположении тайлов
var door_locations := {}

func setup_room(data: Dictionary):
	$TileMap.clear()
	room_data = data
	
	# Заполняем TileMap
	for layer in data.layers:
		for cell in layer.cells:
			$TileMap.set_cell(layer, cell.position, cell.source_id, cell.atlas_coords)
	
	# Запоминаем позиции дверей
	for door in data.doors:
		door_locations[door.direction] = door.position

func get_door_position(direction: String) -> Vector2:
	return door_locations.get(direction, Vector2.ZERO)
