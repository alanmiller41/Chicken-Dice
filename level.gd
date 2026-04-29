extends Node2D

# Level loads when you select play on the main menu

var Players = []
var UI

# Called when the node enters the scene tree for the first time.
func _ready():
	
	UI = $UI
	
	var player_scene = preload("res://player.tscn")
	
	for i in range(Global.player_count):
		var player = player_scene.instantiate()
		player.player_number = i+1
		player.start_player_turn.connect(UI.on_start_player_turn)
		add_child(player)
		Players.append(player)
		
	# Set first player turn
	Players[0].start_turn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
