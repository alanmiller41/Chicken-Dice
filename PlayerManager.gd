extends Node

var Players: Array[Player] = []
var active_player: Player
var dice
var UI

# Called when the node enters the scene tree for the first time.
func _ready():
	UI = $"../UI"
	dice = $"../Dice"
	
	var player_scene = preload("res://player.tscn")
	
	for i in range(Global.player_count):
		var player = player_scene.instantiate()

		player.player_number = i+1
		
		add_child(player)
		Players.append(player)
		
	# Set first player turn
	connect_player_signals(0)
	Players[0].start_turn(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_player_turn(player_num: int, score_to_steal: int):
	disconnect_player_signals(player_num-1)
	print("player turn ended")
	if player_num >= Global.player_count:
		connect_player_signals(0)
		Players[0].start_turn(score_to_steal)
		active_player = Players[0]
	else:
		connect_player_signals(player_num)
		Players[player_num].start_turn(score_to_steal)
		active_player = Players[player_num]

# This connects and disconnects all signals to player objects as they start and end
# their turns.  If you add a signal from or to Player.tscn you must add it to these methods
func connect_player_signals(player_num):
	# Connect player signals to other nodes
	Players[player_num].start_player_turn.connect(UI._on_start_player_turn)
	Players[player_num].end_player_turn.connect(UI._on_end_player_turn)
	Players[player_num].end_player_turn.connect(_on_end_player_turn)
	Players[player_num]._on_roll_score_changed.connect(UI._on_roll_score_changed)
	Players[player_num].display_player_message.connect(UI._on_display_player_message)
	Players[player_num].on_total_score_changed.connect(UI._on_player_on_total_score_changed)
	Players[player_num].toggle_roll_button.connect(UI._on_player_toggle_roll_button)
	Players[player_num].hot_dice.connect(dice._on_player_hot_dice)
	Players[player_num].roll_dice.connect(dice._on_player_rolls_dice)
	Players[player_num].steal_roll_dice.connect(dice._on_player_steal_rolls_dice)
	Players[player_num].toggle_end_turn_button.connect(UI._on_player_toggle_end_turn_button)
	Players[player_num].toggle_steal_button.connect(UI._on_player_toggle_steal_button)
	
	# Connect external signals to player
	dice.on_die_held.connect(Players[player_num]._on_die_held)
	dice.on_die_released.connect(Players[player_num]._on_die_released)
	dice.dice_finished_rolling.connect(Players[player_num]._on_dice_dice_finished_rolling)
	
	UI.on_roll_button_pressed.connect(Players[player_num]._on_roll_button_pressed)
	UI.on_end_turn_button_pressed.connect(Players[player_num]._on_end_turn_button_pressed)
	UI.on_steal_button_pressed.connect(Players[player_num]._on_steal_button_pressed)
	
func disconnect_player_signals(player_num):
	Players[player_num].start_player_turn.disconnect(UI._on_start_player_turn)
	Players[player_num].end_player_turn.disconnect(UI._on_end_player_turn)
	Players[player_num].end_player_turn.disconnect(_on_end_player_turn)
	Players[player_num]._on_roll_score_changed.disconnect(UI._on_roll_score_changed)
	Players[player_num].display_player_message.disconnect(UI._on_display_player_message)
	Players[player_num].on_total_score_changed.disconnect(UI._on_player_on_total_score_changed)
	Players[player_num].toggle_roll_button.disconnect(UI._on_player_toggle_roll_button)
	Players[player_num].hot_dice.disconnect(dice._on_player_hot_dice)
	Players[player_num].roll_dice.disconnect(dice._on_player_rolls_dice)
	Players[player_num].steal_roll_dice.disconnect(dice._on_player_steal_rolls_dice)
	Players[player_num].toggle_end_turn_button.disconnect(UI._on_player_toggle_end_turn_button)
	Players[player_num].toggle_steal_button.disconnect(UI._on_player_toggle_steal_button)
	
	# Connect external signals to player
	dice.on_die_held.disconnect(Players[player_num]._on_die_held)
	dice.on_die_released.disconnect(Players[player_num]._on_die_released)
	dice.dice_finished_rolling.disconnect(Players[player_num]._on_dice_dice_finished_rolling)
	
	UI.on_roll_button_pressed.disconnect(Players[player_num]._on_roll_button_pressed)
	UI.on_end_turn_button_pressed.disconnect(Players[player_num]._on_end_turn_button_pressed)
	UI.on_steal_button_pressed.disconnect(Players[player_num]._on_steal_button_pressed)
