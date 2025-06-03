extends Room
@onready var begin_help = $Begin

#func ready():
	# Вызываем кастомную функцию при создании объекта
	#_on_instantiate()

# Ваша функция для инициализации
#
func ready():
	if Global.current_level != 1:
		begin_help.visible = false
	#else:
	#	begin_help.visible = true
#	clear_check()	
