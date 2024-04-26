extends Node

func _ready():
	$DialogueBox.hide()

func _on_world_start_conversation(character_name):
	$DialogueBox.show()

func _on_world_end_conversation():
	$DialogueBox.hide()
	
func _on_dialogue_box_send_message(message):
	$EidolonHandler.post_message(message)

func _on_eidolon_handler_get_process_id(process_id):
	var message = "Process ID: %s" % process_id
	$DialogueBox.add_message("SYSTEM", message)
	
func _on_eidolon_handler_new_message():
	$DialogueBox.add_message("AGENT")

func _on_eidolon_handler_get_message(message):
	$DialogueBox.update_last_message(message)
	
func _on_eidolon_handler_finish_message():
	$DialogueBox.waiting = false


