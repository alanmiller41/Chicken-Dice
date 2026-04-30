extends Control

var roll_button
var turn_score_label
var message_box
var end_turn_button
var total_score_label
var total_score_labels = []

signal on_roll_button_pressed
signal on_end_turn_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_button = $RollButton
	roll_button.pressed.connect(_on_roll_button_pressed)
	roll_button.scale = Vector2(3,3)
	roll_button.position = Vector2(400,500)
	
	end_turn_button = $EndTurnButton
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	end_turn_button.scale = Vector2(3,3)
	end_turn_button.position = Vector2(600, 500)
	
	turn_score_label = $TurnScore
	turn_score_label.scale = Vector2(2,2)
	turn_score_label.position = Vector2(800,50)
	
	for i in range(Global.player_count):
		var label = Label.new()
		label.scale = Vector2(2,2)
		label.position = Vector2(50, 150 + (i*50))
		label.text = "Player %d Score: 0" % (i+1)
		add_child(label)
		total_score_labels.append(label)
	
	message_box = $MessageBox
	message_box.scale = Vector2(3,3)
	message_box.position = Vector2(350,300)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_roll_button_pressed():
	on_roll_button_pressed.emit()

func _on_end_turn_button_pressed():
	on_end_turn_button_pressed.emit()

func _on_roll_score_changed(new_score):
	turn_score_label.text = ("Roll Score: %d" % new_score)

func _on_display_player_message(message, time):
	$MessageBox/MessageTimer.wait_time = time
	$MessageBox/MessageTimer.start()
	$MessageBox.text = message

func _on_message_timer_timeout():
	$MessageBox.text = ""

func _on_player_on_total_score_changed(player, score):
	total_score_labels[player-1].text = "Player %d Score: %d" % [player, score]

func _on_player_toggle_roll_button(toggle: bool):
	roll_button.disabled = !toggle
	
func _on_player_toggle_end_turn_button(toggle: bool):
	end_turn_button.disabled = !toggle
	
func _on_start_player_turn(player):
	total_score_labels[player-1].add_theme_color_override("font_color", Color("fcff00"))
	end_turn_button.disabled = true
	
func _on_end_player_turn(player):
	total_score_labels[player-1].add_theme_color_override("font_color", Color("ffff"))
