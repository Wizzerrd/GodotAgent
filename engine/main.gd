extends Node

func _on_eidolon_handler_get_process_id(process_id):
	var message = "Process ID: %s" % process_id
	$UI.add_message("SYSTEM", message)

func _on_ui_send_message(message):
	$EidolonHandler.post_message(message)

func _on_eidolon_handler_get_message(message):
	$UI.update_last_message(message)
	
func _on_eidolon_handler_new_message():
	$UI.add_message("AGENT")
	
func _on_eidolon_handler_finish_message():
	$UI.waiting = false



