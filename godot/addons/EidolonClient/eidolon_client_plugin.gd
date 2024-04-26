@tool 
extends EditorPlugin

func _enter_tree():
	add_custom_type("EidolonHandler", "Node", preload("EidolonHandler.gd"), preload("res://addons/EidolonClient/icon.png"))
	pass

func _exit_tree():
	remove_custom_type("EidolonHandler")
	pass
