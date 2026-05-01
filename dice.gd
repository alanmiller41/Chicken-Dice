extends Node2D

var dice: Array[Die] = []

@export var debug_roll_values = []
@export var debug_rolls = false

var dice_rolled = false

signal on_die_held
signal on_die_released
signal dice_finished_rolling

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 6:
		var die = preload("res://die.tscn").instantiate()
		add_child(die)
		dice.append(die)
		die.on_hold.connect(die_held)
		die.on_release.connect(die_released)
		die.timer = $RollTimer
		dice[i].scale = Vector2(5,5)
		dice[i].position = Vector2(i*120 + 70, 70)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func roll_dice():
	for die in dice:
		if die.hot_dice:
			die.end_hot_dice()
		if die.held:
			die.permahold()
		else:
			die.roll()
			die.enable_collision()
		$RollTimer.start()
	
func reset_dice(dice):
	for die in dice:
		die.rolled = false
		
# Pass held die to player for scoring
func die_held(die):
	on_die_held.emit(die)
	
# Remove released die from player for scoring
func die_released(die):
	on_die_released.emit(die)


func on_roll_button_pressed():
	roll_dice()

func _on_ui_steal_button_pressed():
	roll_dice()

func _on_roll_timer_timeout():
	var rolled_dice = []
	var i = 0
	for die in dice:
		if die.rolling:
			die.stop_rolling()
			if debug_rolls:
				die.value = debug_roll_values[i]
			rolled_dice.append(die)
		i += 1
	dice_finished_rolling.emit(rolled_dice)


func _on_player_hot_dice():
	for die in dice:
		die.animate_hot_dice()
		await get_tree().create_timer(.1).timeout


func _on_end_turn_button_pressed():
	for die in dice:
		if die.hot_dice:
			die.end_hot_dice()
		if !Global.steals_enabled:
			die.reset()
		die.disable_collision()



