extends CanvasLayer

var time = 0

func _physics_process(delta: float) -> void:
	time = float(time) + delta
	update_speedrun_time
	
