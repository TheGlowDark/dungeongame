extends Control

func resume():
	get_tree().paused = false
	print("!")
	hide()  # Скрываем меню паузы при возобновлении

func pause():
	get_tree().paused = true
	show()  # Показываем меню паузы

func testEsc():
	if Input.is_action_just_pressed("Escape"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _ready():
	hide()  # Скрываем меню при старте

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()  # Сначала снимаем паузу
	get_tree().reload_current_scene()  # Затем перезагружаем сцену

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	testEsc()
