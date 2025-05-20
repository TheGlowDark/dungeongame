extends Area2D

@export var target_room: Node2D  # Ссылка на префаб новой комнаты
@export var door_direction: String = "north"  # Направление двери

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("room_manager", "change_room", target_room, door_direction)
