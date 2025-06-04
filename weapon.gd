extends Area2D

var rotation_speed = 10
@onready var player = $".."
@onready var animationplayer = $AnimationPlayer
@export var damage = 1
@export var attack_stun_time = 0.2
var direction
#func _ready():


var enemies_in_area: Array[Enemy] = []  # Массив для хранения противников в зоне

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		if body not in enemies_in_area and player.is_attack:
			body._take_damage(damage)
		enemies_in_area.append(body)  # Добавляем противника в массив
		enemy_stun(body)

func enemy_stun(body):
#	pass
	body.set_process(false)
	body.set_physics_process(false)
	await get_tree().create_timer(attack_stun_time).timeout 
	body.set_process(true)
	body.set_physics_process(true)

func _on_body_exited(body: Node) -> void:
	if body is Enemy and body in enemies_in_area:
		enemies_in_area.erase(body)  # Удаляем, если вышел из зоны
			
func _process(_delta):
	if(!player.is_attack):
		idle()
	if player.is_alive:
		var mouse_pos = get_global_mouse_position()
		direction = (mouse_pos - $".".global_position).normalized()
		var target_angle = direction.angle()
	
		rotation = lerp_angle(rotation, target_angle, rotation_speed * _delta)
		scale.y = -1 if direction.x < 0 else 1



#func _on_body_entered(body) -> void:
	#if body is Enemy and player.is_attack:
		#body._take_damage(damage)
	##	body.fsm.current_state.state_transition.emit(body.fsm.current_state, "hurt")
		
func attack():
	animationplayer.play("attack")
	for enemy in enemies_in_area:
		if enemy and is_instance_valid(enemy):  # Проверяем, что enemy не удалён
			enemy._take_damage(damage)
	
func idle():
	animationplayer.play("idle")
