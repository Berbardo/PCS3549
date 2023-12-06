extends Area2D
var BUTTON_LEFT = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var has_ball = false
var canclick = false
var t = 0.0
var move
var  p0 = get_global_position()
var  p1 = Vector2(5,5)
var  p2 = get_global_position() + Vector2(10,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if move: 
		t += delta
		position = _quadratic_bezier(p0, p1, p2, t)
		if t>1:
			t = 0
			move = false
	
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
	
func _change_positon(final: Vector2, up: int):
	move = true
	p0 = get_global_position()
	p2 = final
	p1 = Vector2((p0.x + p2.x)/2 ,150*up)
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and canclick:
			print(has_ball)
			if has_ball:
				$AnimatedSprite2D.animation =  "cup_ball"
			else:
				$AnimatedSprite2D.animation =  "cup_no_ball"
			$AnimatedSprite2D.play()
	
