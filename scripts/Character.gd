class_name CharacterBase extends CharacterBody2D


@onready var sprite := $Sprite2D
@export var health : int
var invincible : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Play universal damage sound effect for any character taking damage and flashing red
#func after_damage_iframes():
	#after_damage_iframes()


#After we are done flashing red, we can take damage again
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


func _die():
	#Remove/destroy this character once it's able to do so unless its the player
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(self) and not self is Player:
		queue_free()

#endregion
