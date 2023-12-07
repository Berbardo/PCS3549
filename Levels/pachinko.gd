
extends Node2D

var BallScene = preload("res://src/ball.tscn")
var EndPanelScene = preload("res://src/end_panel.tscn")
var GameOverPanelScene = preload("res://src/game_over_panel.tscn")
var WinPanelScene = preload("res://src/win_panel.tscn")
var MAX_SPEED = 3000
var strength = 0

var current_marbles = 10
var reward_marables = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	TweenUtils.audio_fade_in($BgmPlayer, 0.3)
	self.create_ball()
	
func create_ball():
	var node = self.BallScene.instantiate()
	node.connect("finished", func ():
		var is_reward1 = $AreaRewardX1.get_overlapping_bodies()
		var target_reward = 0
		if is_reward1:
			target_reward = self.current_marbles + reward_marables
			self.win()
			
	
		if target_reward != 0:
			var tween = self.create_tween()
			tween.set_parallel(true)
			var duration = 0.5
			tween.tween_property(self, "current_marbles", target_reward, duration)
			tween.tween_property(self, "reward_marables", 0, duration)
			await tween.finished
			await self.get_tree().create_timer(0.5).timeout
		
		self.current_marbles -= 1
		if self.current_marbles == 0:
			print_debug("Game over")
			self.show_game_over()
			return
		self.create_ball()
	)
	$Balls.add_child(node)
	TweenUtils.show(node, 0.1, { "scale": false, "modulate": true })
	TweenUtils.show($Strength, 0.2)

func _input(event):
	if event.is_action("escape"):
		if get_tree().change_scene_to_file("res://Levels/festa_junina.tscn") != OK:
			print ("Error changing scene to Overworld")

func _process(delta):
	$GUI/Panel/HBoxContainer2/Current.text = "[center]LIVES: %s" % str(self.current_marbles) + "[/center]"

	if $Balls.get_child_count() <= 0:
		return
	if $Balls.get_children()[0].is_shot:
		return
	if $GUI.has_node("EndPanel"):
		return
	if Input.get_action_strength("player_shot") > 0:
		if strength == 0:
			$EffectPlayer.stream = ResourceManager.load_file("res://assets/sounds/gather_strength.wav")
			$EffectPlayer.play()
		strength += delta
		strength = min(strength, 1.0)
	elif Input.is_action_just_released("player_shot"):
		$EffectPlayer.stream = ResourceManager.load_file("res://assets/sounds/shot.wav")
		$EffectPlayer.play()
		var node = $Balls.get_children()[0]
		node.is_shot = true
		TweenUtils.hide($Strength, 0.3)
		node.linear_velocity.y = -MAX_SPEED * strength
		print_debug(node.linear_velocity.y)
		strength = 0
	$Strength.value = strength * 100

func show_game_over():
	var panel = self.GameOverPanelScene.instantiate()
	MaskUtils.show_mask(self)
	$GUI.add_child(panel)
	await TweenUtils.show(panel)
	GameManager.top_points = max(GameManager.top_points, self.current_marbles)
	panel.get_node("MarginContainer/VBoxContainer/Content").text = "GAME OVER"
	panel.get_node("MarginContainer/VBoxContainer/HBoxContainer/Yes").connect("pressed", func ():
		TweenUtils.audio_fade_out($BgmPlayer, 0.3)
		TweenUtils.hide(panel)
#		TweenUtils.hide($GUI, 0.3, { "modulate": true, "scale": false})\
		if get_tree().change_scene_to_file("res://Levels/pachinko.tscn") != OK:
			print ("Error changing scene to pachinko"))

func win():
	var panel = self.WinPanelScene.instantiate()
	MaskUtils.show_mask(self)
	$GUI.add_child(panel)
	await TweenUtils.show(panel)
	GameManager.top_points = max(GameManager.top_points, self.current_marbles)
	panel.get_node("MarginContainer/VBoxContainer/HBoxContainer/Yes").connect("pressed", func ():
		TweenUtils.audio_fade_out($BgmPlayer, 0.3)
		TweenUtils.hide(panel)
		if get_tree().change_scene_to_file("res://Levels/festa_junina.tscn") != OK:
			print ("Error changing scene to pachinko"))
		# Change to load next scene

