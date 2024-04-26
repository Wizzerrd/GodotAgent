extends Node2D

var player

signal start_conversation(character_name)
signal end_conversation

func _on_start_conversation(character_name):
	player.talking = true

func _on_end_conversation():
	player.talking = false
