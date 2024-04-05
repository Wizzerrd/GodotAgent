extends Node

func _on_eidolon_handler_get_process_id(process_id):
	var message = "Process ID: %s" % process_id
	$UI.add_message("SYSTEM", message)

func _on_ui_send_message(message):
	$EidolonHandler.post_message(message)

func _on_eidolon_handler_get_message(message):
	$UI.add_message("AGENT", message)
	$UI.waiting = false
