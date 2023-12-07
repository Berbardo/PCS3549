extends AnimatedSprite2D

func _unhandled_input(event):
	if event.is_action_pressed('left'):
		frame = 1
	elif event.is_action_pressed('right'):
		frame = 2
	elif event.is_action_pressed('up'):
		frame = 3
	elif event.is_released():
		frame = 0
