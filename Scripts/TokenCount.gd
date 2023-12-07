extends Label

func _process(_delta):
	self.text = "Tokens: " + str(GameState.token_count)
