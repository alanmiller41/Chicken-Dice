extends Node2D

# Level loads when you select play on the main menu

var Players = []
var dice
var UI

# Called when the node enters the scene tree for the first time.
func _ready():
	
	UI = $UI
	dice = $Dice
	
	var player_scene = preload("res://player.tscn")
	
	for i in range(Global.player_count):
		var player = player_scene.instantiate()
		player.player_number = i+1
		
		# Connect player signals to other nodes
		player.start_player_turn.connect(UI.on_start_player_turn)
		player.end_player_turn.connect(UI.on_end_player_turn)
		player.end_player_turn.connect(on_end_player_turn)
		player._on_roll_score_changed.connect(UI._on_roll_score_changed)
		player.display_player_message.connect(UI._on_display_player_message)
		player.on_total_score_changed.connect(UI._on_player_on_total_score_changed)
		player.toggle_roll_button.connect(UI._on_player_toggle_roll_button)
		player.hot_dice.connect(dice._on_player_hot_dice)
		
		# Connect external signals to player
		dice.on_die_held.connect(player.on_die_held)
		dice.on_die_released.connect(player.on_die_released)
		dice.dice_finished_rolling.connect(player._on_dice_dice_finished_rolling)
		
		UI.on_roll_button_pressed.connect(player._on_roll_button_pressed)
		UI.on_end_turn_button_pressed.connect(player._on_end_turn_button_pressed)
		
		add_child(player)
		Players.append(player)
		
	# Set first player turn
	Players[0].start_turn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_end_player_turn(player_num):
	print("player turn ended")
	if player_num >= Global.player_count:
		Players[0].start_turn()
	else:
		Players[player_num].start_turn()
