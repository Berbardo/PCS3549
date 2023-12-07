extends Node

var token_count: int = 0
var DDR : bool = false
var cup : bool = false
var pachinko : bool = false

var completed_games: int = 0

func _process(_delta):
	completed_games = int(DDR) + int(cup) + int(pachinko)
