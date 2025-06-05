extends Control
@onready var line_edit = $Panel/VBoxContainer/LineEdit
var score = Global.score
var player_name:String

func _ready():
	hide()
	$LeaderboardUI.hide()
	
	
func appear():
	get_tree().paused = true
	visible = true
	$Panel/VBoxContainer/Score.text += $"../Control/VBoxContainer/Score".text
	line_edit.text = Global.player_name
	await Leaderboards.post_guest_score("waximum-waximum-3ZPC", Global.score, Global.player_name)
	

func _on_line_edit_text_changed(new_text: String) -> void:
	Global.player_name = new_text
#	print(player_name)


func _on_submit_pressed() -> void:
	print()
	await Leaderboards.post_guest_score("waximum-waximum-3ZPC", Global.score, Global.player_name)
#	$LeaderboardUI


func _on_button_pressed() -> void:
	$LeaderboardUI.hide()
	visible = true


func _on_restart_pressed() -> void:
	get_tree().paused = false
	Global.reset()
	get_tree().reload_current_scene()  # Затем перезагружаем сцену

func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_leader_board_pressed() -> void:
#	hide()
	$LeaderboardUI.show()
	
