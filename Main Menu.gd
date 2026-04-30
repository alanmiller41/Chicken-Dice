extends Node2D

#var player_count = 1
var player_count_label

# Called when the node enters the scene tree for the first time.
func _ready():
	player_count_label = $ButtonManager/PlayerCountLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://level.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_player_count_plus_pressed():
	if Global.player_count <= 3:
		Global.player_count += 1
		player_count_label.text = "Players: %d" % Global.player_count
		

func _on_player_count_minus_pressed():
	if Global.player_count > 1:
		Global.player_count -= 1
		player_count_label.text = "Players: %d" % Global.player_count


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")
