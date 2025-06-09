extends Node

var player_name = "Player"

var dif_multiplier = 1
const dif_initial = 1.0
@export var max_dif = 2
@export var k = 0.05


var current_level = 1
#var level_up_counter = 1
@export var score_for_floor = 1000
var initial_score_for_floor = 1000
var score :int = 0 
#@export var butcher_speed_base = 120
#@export var cultist_speed_base = 50
#@export var bullet_speed_base = 250
var room_add = 0
@export var room_add_limit = 15
@export var hp_drop_propability_initial = 0.3
@export var min_hp_drop_propability = 0.05
var hp_drop_propability = hp_drop_propability_initial




func reset():
	dif_multiplier = dif_initial
	current_level = 1
	score = 0 
#	level_up_counter = 1
	#@export var butcher_speed_base = 120
	#@export var cultist_speed_base = 50
	#@export var bullet_speed_base = 250
	room_add = 0
	score_for_floor = initial_score_for_floor
	hp_drop_propability = hp_drop_propability_initial
	#enemy_speed_up()

func floor_up():
	score += 1000 * dif_multiplier**dif_multiplier
#	level_up_counter += 1
	#if level_up_counter >= current_level:
	dif_up()
	if current_level % 2 == 0 and room_add < room_add_limit:
		room_add += 1


func dif_up():
	dif_multiplier = min(max_dif, dif_initial + k * current_level)
	#if (hp_drop_propability > 10):
	hp_drop_propability = max(min_hp_drop_propability, max_dif - dif_multiplier * hp_drop_propability_initial)
	#enemy_speed_up()
		
func kill_score(k_score):
	return k_score * dif_multiplier * dif_multiplier
#func enemy_speed_up():
	#butcher_speed_base = 120 * multiplier 
	#cultist_speed_base = 50 * multiplier
	#bullet_speed_base = 250 * multiplier
