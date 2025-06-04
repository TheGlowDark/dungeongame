extends Node


var dif_multiplier = 1.1
var current_level = 1
var player_name = "Player"
var level_up_counter = 1
var score_for_floor = 1000
var score :int = 0 
var time_score_lose = 10
#@export var butcher_speed_base = 120
#@export var cultist_speed_base = 50
#@export var bullet_speed_base = 250
var Room_add = 0
var hp_drop_propability = 25






func reset():
	dif_multiplier = 1.1
	current_level = 1
	level_up_counter = 1
	score_for_floor = 1000
	score = 0 
	time_score_lose = 10
	#@export var butcher_speed_base = 120
	#@export var cultist_speed_base = 50
	#@export var bullet_speed_base = 250
	Room_add = 0
	hp_drop_propability = 25
	#enemy_speed_up()

func floor_up():
	score += 1000 * dif_multiplier
	level_up_counter += 1
	if level_up_counter >= current_level:
		dif_up()
	else:
		level_up_counter = 0
	if current_level % 2 == 2 and Room_add < 15:
		Room_add += 1


func dif_up():
	if(dif_multiplier <= 1.5):
		dif_multiplier += 0.1
	if (hp_drop_propability > 10):
		hp_drop_propability -= 2
	#enemy_speed_up()
		
		
#func enemy_speed_up():
	#butcher_speed_base = 120 * multiplier 
	#cultist_speed_base = 50 * multiplier
	#bullet_speed_base = 250 * multiplier
