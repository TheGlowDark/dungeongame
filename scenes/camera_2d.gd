extends Camera2D

var d_offset: Vector2
var min_offset = -128
var max_offset = 128

func _ready() -> void:
	position = $"..".start_position

func start():
	global_position = get_parent().get_node("Player").global_position

func _process(_delta: float) -> void:
	d_offset = (get_global_mouse_position() - position) * 0.5
	d_offset.x = clamp(d_offset.x, min_offset, max_offset)
	d_offset.y = clamp(d_offset.y, min_offset / 2.0, max_offset / 2.0)
	global_position = get_parent().get_node("Player").global_position + d_offset
