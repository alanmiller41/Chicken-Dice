extends Node2D

var score = 0
var is_players_turn = false

var player_number = 1

var held_dice = []
var already_counted_dice_indices = []
var turn_value = 0
var roll_value = 0

signal _on_roll_score_changed
signal display_player_message
signal on_total_score_changed
signal toggle_roll_button
signal hot_dice

signal start_player_turn
signal end_player_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_turn():
	is_players_turn = true
	start_player_turn.emit(player_number)
	
func end_turn():
	#TODO pass turn to next player
	is_players_turn = false
	end_player_turn.emit(player_number)
	turn_value = 0

func determine_roll_value(dice):
	set_all_dice_scored(dice, false)
	roll_value = 0
	if dice.size() >= 6:
		roll_value += get_three_pairs_value(dice)
		roll_value += get_three_by_two_value(dice)
		if roll_value > 0:
			set_all_dice_scored(dice, true)
	if dice.size() >= 5 and roll_value == 0:
		roll_value += get_straight_value(dice)
	if dice.size() >= 3:
		roll_value += get_x_of_a_kind_value(dice)
	
	roll_value += get_one_and_five_values(dice)
	
	# Check for hot dice
	if dice.size() > 0:
		var hot_dice = true
		for die in dice:
			if not die.scored or die.held:
				hot_dice = false
		if hot_dice:
			turn_value += roll_value
			_on_roll_score_changed.emit(turn_value)
			handle_hot_dice(dice)
	
	return roll_value

func _on_dice_rolled(dice):
	pass

func get_x_of_a_kind_value(dice):
	var dice_values = []
	for die in dice:
		if not die.scored:
			dice_values.append(die.value)
	for i in range(1,7):
		var val_count = dice_values.count(i)
		if val_count == 3:
			display_player_message.emit("Three Of A Kind!", 2)
			if i == 1:
				set_dice_of_value_scored(dice, i, true)
				return 1000
			else:
				set_dice_of_value_scored(dice, i, true)
				return i * 100
		if val_count == 4:
			display_player_message.emit("Four of A Kind!", 2)
			if i == 1:
				set_dice_of_value_scored(dice, i, true)
				return 2000
			else:
				set_dice_of_value_scored(dice, i, true)
				return i * 200
		if val_count == 5:
			display_player_message.emit("Five of A Kind!", 2)
			if i == 1:
				set_dice_of_value_scored(dice, i, true)
				return 4000
			else:
				set_dice_of_value_scored(dice, i, true)
				return i * 400
		if val_count == 6:
			display_player_message.emit("Six of A Kind!", 2)
			if i == 1:
				set_dice_of_value_scored(dice, i, true)
				return 8000
			else:
				set_dice_of_value_scored(dice, i, true)
				return i * 800
	return 0
	
func get_straight_value(dice):
	var unique_values = []
	for die in dice:
		if not unique_values.has(die.value):
			unique_values.append(die.value)
			die.scored = true
	if unique_values.size() == 6:
		print("long straight!")
		display_player_message.emit("Long Straight!", 1)
		set_all_dice_scored(dice, true)
		return 2000
	if unique_values.size() == 5 and unique_values.has(2) \
	and unique_values.has(3) and unique_values.has(4) and unique_values.has(5):
		display_player_message.emit("Short Straight!", 1)
		print("short straight!")
		return 1000
	set_all_dice_scored(dice, false)
	return 0
	
	
func get_three_pairs_value(dice):
	var dice_values = []
	for die in dice:
		dice_values.append(die.value)
	for i in range(1,4):
		if dice_values.count(i) == 2:
			for j in range (i+1,7):
				if dice_values.count(j) == 2:
					for k in range (j+1,7):
						if dice_values.count(k) ==2:
							print("three pairs!")
							display_player_message.emit("Three Pairs!", 1)
							set_all_dice_scored(dice, true)
							return 1500
	return 0
	
func get_three_by_two_value(dice):
	var dice_values = []
	for die in dice:
		dice_values.append(die.value)
	for i in range(1,7):
		if dice_values.count(i) == 3:
			for j in range(i+1,7):
				if dice_values.count(j) == 3:
					set_all_dice_scored(dice, true)
					display_player_message.emit("Two by Three!", 1)
					print("two three of a kinds!")
					return 2000
	return 0

func get_one_and_five_values(dice):
	var ones_fives_score = 0
	for die in dice:
		if die.value == 1 and not die.scored:
			ones_fives_score += 100
			die.scored = true
		if die.value == 5 and not die.scored:
			ones_fives_score += 50
			die.scored = true
	return ones_fives_score


func on_die_held(die):
	
	if not die.perma_held:
		held_dice.append(die)
	var held_dice_score = determine_roll_value(held_dice)
	if held_dice.size() > 0 and held_dice_score > 0:
		toggle_roll_button.emit(true) 
	_on_roll_score_changed.emit(turn_value + held_dice_score)


func on_die_released(die):
	held_dice.erase(die)
	if held_dice.size() == 0:
		toggle_roll_button.emit(false)
	_on_roll_score_changed.emit(turn_value + determine_roll_value(held_dice))
	
func set_dice_of_value_scored(dice, val, scored):
	for die in dice:
		if die.value == val:
			die.scored = scored

func set_all_dice_scored(dice, scored):
	for die in dice:
		die.scored = scored
		
func handle_hot_dice(dice):
	display_player_message.emit("Hot Dice!", 2)
	for die in dice:
		die.held = false
		die.perma_held=false
	hot_dice.emit()
	toggle_roll_button.emit(true)
	
func _on_dice_dice_finished_rolling(dice):
	# If player busted
	if determine_roll_value(dice) == 0:
		turn_value = 0
		display_player_message.emit("You Busted All Over!", 2)
		end_turn()


func _on_roll_button_pressed():
	# TODO unhold any dice that aren't a part of the score
	turn_value += determine_roll_value(held_dice)
	toggle_roll_button.emit(false)
	held_dice = []


func _on_end_turn_button_pressed():
	turn_value += roll_value
	score += turn_value
	turn_value = 0
	on_total_score_changed.emit(player_number, score)
	toggle_roll_button.emit(true)
	end_turn()
