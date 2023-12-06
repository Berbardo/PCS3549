extends Node2D

var cup
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	cup = [$cup0, $cup1, $cup2]
	cup[1].has_ball = true
	_start_game(2)

var isGame = false
var start = 0
var steps = 4
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !cup[start].move && steps != 0:
		start = _start_game(0)
		steps = steps - 1
		if steps == 0: 
			for c in cup:
				c.canclick = true
	
	
func _start_game(steps: int):
	
	start = randi_range(0, 2)
	var end = randi_range(0, 2)
	while  (start == end):
		end = randi_range(0, 2)
	
	var sLoc = cup[start].get_global_position()
	cup[start]._change_positon(cup[end].get_global_position(), 1)
	cup[end]._change_positon(sLoc, -1)
			
	return start
	
	
