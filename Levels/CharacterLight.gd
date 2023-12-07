extends PointLight2D

func _process(_delta):
	self.energy = 1 - GameState.completed_games * 0.2
