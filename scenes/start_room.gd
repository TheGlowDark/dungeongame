extends Room
@onready var begin_help = $Begin

#func ready():
	# Вызываем кастомную функцию при создании объекта
	#_on_instantiate()

# Ваша функция для инициализации
#
func _ready():
	if Global.current_level != 1:
		print(Global.current_level)
		begin_help.queue_free()

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if Global.current_level == 1 and body is Player and !entered:
		#begin_help.visible = false
		#clear_check()
		#is_entered = true
