extends CanvasLayer

@export var message_container_scene: PackedScene

var waiting = false

signal send_message(message)

func add_message(sender, text):
	var container = message_container_scene.instantiate()
	var name = Label.new()
	var message = Label.new()
	name.text = sender + " -"
	message.autowrap_mode = 3
	message.text = text
	message.custom_minimum_size = Vector2(1000,0)
	container.add_child(name)
	container.add_child(VSeparator.new())
	container.add_child(message)
	$ScrollContainer/VBoxContainer.add_child(HSeparator.new())
	$ScrollContainer/VBoxContainer.add_child(container)
	
func validate_message(message):
	if not (
		ensure_message_contents(message)
	):
		return false
	return true
	
func ensure_message_contents(message):
	for i in range(len(message)):
		if (
			message[i] != ' ' 
			and message[i] != '\n' 
			and message[i] != '\t'
		):
			return true
	return false
	
func _on_button_pressed():
	if not waiting:
		var message = $MessageInput.text
		if validate_message(message):
			$MessageInput.clear()
			add_message("USER", message)
			waiting = true
			send_message.emit(message)
		
