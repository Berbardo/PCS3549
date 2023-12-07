extends Sprite2D

func _process(_delta):
	self.modulate.a = 0.1 + 0.3 * GameState.completed_games
