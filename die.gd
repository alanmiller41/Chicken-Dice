extends Node2D

class_name Die

var normal_dice_sprites = [preload("res://Sprites/Dice/dice_1_dragging.png"),
preload("res://Sprites/Dice/dice_2_dragging.png"),
preload("res://Sprites/Dice/dice_3_dragging.png"),
preload("res://Sprites/Dice/dice_4_dragging.png"),
preload("res://Sprites/Dice/dice_5_dragging.png"),
preload("res://Sprites/Dice/dice_6_dragging.png")]

var hover_dice_sprites = [preload("res://Sprites/Dice/dice_1_hover.png"),
preload("res://Sprites/Dice/dice_2_hover.png"),
preload("res://Sprites/Dice/dice_3_hover.png"),
preload("res://Sprites/Dice/dice_4_hover.png"),
preload("res://Sprites/Dice/dice_5_hover.png"),
preload("res://Sprites/Dice/dice_6_hover.png")]

var hold_dice_sprites = [preload("res://Sprites/Dice/dice_1_normal.png"),
preload("res://Sprites/Dice/dice_2_normal.png"),
preload("res://Sprites/Dice/dice_3_normal.png"),
preload("res://Sprites/Dice/dice_4_normal.png"),
preload("res://Sprites/Dice/dice_5_normal.png"),
preload("res://Sprites/Dice/dice_6_normal.png")]

var perma_hold_dice_sprites = [preload("res://Sprites/Dice/dice_1_perma_hold.png"),
preload("res://Sprites/Dice/dice_2_perma_hold.png"),
preload("res://Sprites/Dice/dice_3_perma_hold.png"),
preload("res://Sprites/Dice/dice_4_perma_hold.png"),
preload("res://Sprites/Dice/dice_5_perma_hold.png"),
preload("res://Sprites/Dice/dice_6_perma_hold.png")]

var hot_dice_animation_sprites = [normal_dice_sprites, hover_dice_sprites, hold_dice_sprites]

var rolling = false
var rolled = false
var held = false
var perma_held = false
var scored = false
var hot_dice = false

var timer

var roll_frame_timer = 0

var hot_dice_frame_timer = 0
var hot_dice_sprite_counter = 0

var value = 0

signal on_hold
signal on_release

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = normal_dice_sprites[value-1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rolling:
		if roll_frame_timer % 5 == 0:
			value = randi_range(1,6)
			$Sprite2D.texture = normal_dice_sprites[value-1]
		roll_frame_timer += 1
		return
	if hot_dice:
		if hot_dice_frame_timer % 10 == 0:
			$Sprite2D.texture = hot_dice_animation_sprites[hot_dice_sprite_counter % 3][value-1]
			hot_dice_sprite_counter += 1
		hot_dice_frame_timer += 1
	
func roll():
	if not held:
		rolling = true
		timer.start()
		
func stop_rolling():
	rolling = false
	rolled = true
	roll_frame_timer = 0
	
func hold():
	held = true
	$Sprite2D.texture = hold_dice_sprites[value-1]
	on_hold.emit(self)

func unhold():
	if not perma_held:
		held = false
		$Sprite2D.texture = normal_dice_sprites[value-1]
		on_release.emit(self)
		
func reset():
	perma_held = false
	held = false
	rolled = false
	$Sprite2D.texture = normal_dice_sprites[value-1]
		
func permahold():
	perma_held = true
	$Sprite2D.texture = perma_hold_dice_sprites[value-1]
	
func animate_hot_dice():
	$Sprite2D/Area2D/CollisionShape2D.disabled = true	
	hot_dice = true

func end_hot_dice():
	$Sprite2D/Area2D/CollisionShape2D.disabled = false	
	hot_dice = false
	reset()
	
func disable_collision():
	$Sprite2D/Area2D/CollisionShape2D.disabled = true

func enable_collision():
	$Sprite2D/Area2D/CollisionShape2D.disabled = false
	
func _on_area_2d_mouse_entered():
	if not held:
		$Sprite2D.texture = hover_dice_sprites[value-1]


func _on_area_2d_mouse_exited():
	if not held:
		$Sprite2D.texture = normal_dice_sprites[value-1]


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("Left_Click"):
		if not held:
			hold()
		else:
			unhold()

