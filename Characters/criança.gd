extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

#If you've allowed 'Resizable' under Display settings you'll need to directly grab this in the _process
@onready var screen_dimensions = Vector2(get_viewport().size)
@onready var camera2D = get_viewport().get_camera_2d()

#Dialogue
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

func _ready():
	update_animation_parameters(starting_direction)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _process(delta) -> void:
	# convert player position to UV position
	var camera_position = camera2D.get_screen_center_position()
	var player_position_relative_to_camera_uv = (global_position - camera_position) / screen_dimensions * 2 + Vector2(0.25, 0.25)
	# Set shader to player position
	get_parent().get_node("CanvasLayer/Vignette").material.set_shader_parameter("player_position", player_position_relative_to_camera_uv)

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	# Update velocity
	velocity = input_direction * move_speed
	
	# Move and Slide
	move_and_slide()
	
	pick_new_state()
	
func update_animation_parameters(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
