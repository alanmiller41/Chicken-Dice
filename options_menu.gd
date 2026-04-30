extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_minimum_button_pressed() -> void:
	Global.minimum_enabled = !Global.minimum_enabled


func _on_steals_button_pressed() -> void:
	Global.steals_enabled = !Global.steals_enabled
