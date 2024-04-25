extends Area2D

var world = null
var player = null
var talking = false
var velocity = Vector2.ZERO

func _ready():
	player = get_parent().player
	world = get_parent()
	$BasicMobSprite.choose_type("knight")
	$Exclamation.hide()
	
func _physics_process(delta):
	$Rotation.look_at(player.global_position)
	$BasicMobSprite.choose_animation(velocity, $Rotation.rotation_degrees)
	z_index = position.y - player.global_position.y
	if Input.is_action_just_pressed("talk") and $Exclamation.visible and not talking: 
		world.start_conversation.emit("knight")
		talking = true
	if Input.is_action_just_pressed("end_conversation") and talking:
		world.end_conversation.emit()
		talking = false

func _on_body_entered(body):
	$Exclamation.show()

func _on_body_exited(body):
	if body == player: $Exclamation.hide()
