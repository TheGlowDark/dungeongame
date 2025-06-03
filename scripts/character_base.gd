class_name character_base extends CharacterBody2D
 
@onready var animation_tree:= $AnimationTree
@onready var animation_state_machine = animation_tree["parameters/playback"] 
@onready var get_player:= get_tree().get_nodes_in_group("player")[0]
@onready var fsm = $state_machine
@export var after_damage_inv_time: float
@onready var after_damage_inv_tick = after_damage_inv_time / 4
#@onready var animation_player = $AnimationTree.get("anim_player")
@onready var sprite := $Sprite2D
@export var health : int
@export var stun_time := 0.0
var invincible : bool = false
@export var hurt_sound: AudioStreamWAV

func damage_effects():
	invincible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK,after_damage_inv_tick)
	tween.tween_property(self, "modulate", Color.WHITE, after_damage_inv_tick)
	tween.tween_property(self, "modulate", Color.BLACK, after_damage_inv_tick)
	tween.tween_property(self, "modulate", Color.WHITE, after_damage_inv_tick)
	await tween.finished
	invincible = false
	
func _take_damage(amount):
	if invincible:
		return
	if health > 0:
		health -= amount
		if health > 0:
			AudioManager.play_sound(hurt_sound, 0, 0.2)
		if self is Player: 
			get_player.update_hp_icons()
		damage_effects()
	
	

func animation_travel(state: String):
	if animation_state_machine != null:
		animation_state_machine.travel(state)
	#else:
	#	push_error("Cannot travel - state machine is null")

func update_animation(direction: Vector2):
	## Устанавливаем blend_position для анимаций
	if(direction != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_tree.set("parameters/hurt/blend_position", direction)
		animation_tree.set("parameters/death/blend_position", direction)
		animation_tree.set("parameters/attack/blend_position", direction)

#
#func animation_travel(state: String):
	#if animation_state_machine != null:
		#animation_state_machine.travel(state)


func _die():
	#Remove/destroy this character once it's able to do so unless its the player
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(self):
		queue_free()

#endregion
