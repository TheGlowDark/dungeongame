class_name character_base extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine = animation_tree["parameters/playback"] 
@onready var sprite := $Sprite2D
@export var health : int
var invincible : bool = false


func damage_effects():
	invincible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	tween.tween_property(self, "modulate", Color.BLACK, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	await tween.finished
	invincible = false
	
func _take_damage(amount):
	if invincible:
		return
	health -= amount
	damage_effects()

func update_animation(direction: Vector2):
	# Устанавливаем blend_position для анимаций
	if(direction != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_tree.set("parameters/hurt/blend_position", direction)
		animation_tree.set("parameters/death/blend_position", direction)


func animation_travel(state: String):
	if animation_state_machine != null:
		animation_state_machine.travel(state)
	else:
		push_error("Cannot travel - state machine is null")



func _die():
	#Remove/destroy this character once it's able to do so unless its the player
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(self):
		queue_free()

#endregion
