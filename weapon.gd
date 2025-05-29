extends Area2D

var rotation_speed = 10
@onready var player = $".."
@onready var animationplayer = $AnimationPlayer

#func _ready():


func _process(_delta):
	if(!player.is_attack):
		idle()
	if player.is_alive:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - $".".global_position).normalized()
		var target_angle = direction.angle()
	
		rotation = lerp_angle(rotation, target_angle, rotation_speed * _delta)
		scale.y = -1 if direction.x < 0 else 1



func _on_body_entered(body) -> void:
	if body is Enemy and player.is_attack:
		body.health -= 1
		
func attack():
	animationplayer.play("attack")
	
func idle():
	animationplayer.play("idle")
