extends Area2D

const Balloon = preload("res://Dialogue/examples/visual_novel_balloon/visual_novel_balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "ddr"

func action() -> void:
	# var balloon: Node = Balloon.instantiate()
	# get_tree().current_scene.add_child(balloon)
	# balloon.start(dialogue_resource, dialogue_start)
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
