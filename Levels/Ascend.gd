extends RichTextLabel

func _process(_delta):
	self.modulate.a = 0
	if GameState.completed_games > 2:
		self.modulate.a = 1
