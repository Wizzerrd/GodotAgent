extends Node

func _ready():
	$DialogueBox.hide()

func _on_world_start_conversation(character_name):
	$DialogueBox.show()

func _on_world_end_conversation():
	$DialogueBox.hide()
