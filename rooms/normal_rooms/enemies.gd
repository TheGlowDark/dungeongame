extends Node2D

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_area_2d_body_entered(body: Node2D) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
