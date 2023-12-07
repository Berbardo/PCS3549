extends Node2D
var BUTTON_LEFT = 1

var cup
var start = 0
var steps = 0
var score = -1 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	cup = [$cup0, $cup1, $cup2]
	start = randi_range(0, 2)
	cup[start].has_ball = true
	for c in cup:
		c.cup_clicked.connect(cup_open)
	show_cup(true)
	
	

var isGame = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if !cup[start].move && steps != 0:
		start = _start_game()
		steps = steps - 1
		if steps == 0: 
			for c in cup:
				c.canclick = true
	
	
func _start_game():
	
	start = randi_range(0, 2)
	var end = randi_range(0, 2)
	while  (start == end):
		end = randi_range(0, 2)
	
	var sLoc = cup[start].get_global_position()
	cup[start]._change_positon(cup[end].get_global_position(), 1)
	cup[end]._change_positon(sLoc, -1)
			
	return start
	
func show_cup(show: bool):
	
	cup = [$cup0, $cup1, $cup2]
	for c in cup:
		if c.open == !show:
			c.click_cup()	
	return
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and $RichTextLabel.visible_ratio == 1:
			print("start")
			$RichTextLabel.visible_ratio = 0
			show_cup(false)
			steps = 3
			
	if event.is_action("escape"):
		if get_tree().change_scene_to_file("res://Levels/festa_junina.tscn") != OK:
			print ("Error changing scene to Overworld")
			
			

func cup_open(has_ball : bool):
	if has_ball: 
		print("Correct")
		score = score + 1
		$Score.text = str(score)
	else: 
		print("Error")
	for c in cup:
		c.canclick = false
	$RichTextLabel.visible_ratio = 1
	
	return
	
	
