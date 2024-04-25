extends Node2D

#################
### Variables ###
#################

# Variable that holds a boolean indicating whether or not the player is walking
# Set in apply_velocity()
# bool
var walking = false

# Variable that holds a boolean indicating whether or not the player is flashing
# Set in start_flashing(), Player node
# bool
var flashing = false

# Variable that holds a boolean indicating whether or not the player sprite is all-white at the moment
# Set in _on_flash_timer_timeout()
# bool
var all_white = false

# Variable that holds a string indicating which direction the player is facing
# Set in _apply_velocity()
# str
var direction = "down"

# Variable that holds a string indicating which animation is currently playing
# Set in choose_animation()
# str
var current_animation = ""

########################
### Custom Functions ###
########################

### choose_skin(incoming_skin: str) ###
# Custom function invoked to set the texture of Sprite2D node
# Called from Player node
func choose_skin(incoming_skin="wizard_white"):
	# Set the path variable to a string interpolated with the incoming_skin argument
	var path = "res://art/%s.png" % incoming_skin
	# Set Sprite2D node's texture to the result of loading the path variable
	$Sprite2D.texture = load(path)

### choose_animation(velocity: Vector2, incoming_modifier: str) ###
# Custom function invoked to choose the proper animation according to incoming parameters
# Called from Player node
func choose_animation(velocity, rotation, incoming_modifier):
	# invoke _apply_velocity logic passing velocity parameter normalized down
	_apply_velocity(velocity.normalized(), rotation, incoming_modifier)
	# assign new variable new_animation to an empty string
	var new_animation = ""
	# If the walking variable is true, start new_animation with "walking_"
	if walking: new_animation += "walking_"
	# If the walking variable is false, start new_animation with "standing_"
	else: new_animation += "standing_"
	# Append incoming_modifier argument + "_" to new_animation variable
	new_animation += incoming_modifier + "_"
	# If the direction is in the y-axis, append the direction variable to new_animation variable
	if direction == "up" or direction == "down": new_animation += direction
	# If the direction is in the x-axis, append "side" to the new_animation variable
	elif direction == "right" or direction == "left": new_animation += "side"
	# Check if the current_animation variable does not match the new_animation variable
	if current_animation != new_animation:
		# Assign the new_animation variable's contents into the current_animation variable
		current_animation = new_animation
		# Invoke AnimationPlayer play logic passing current_animation as the argument
		$AnimationPlayer.play(current_animation)
	
### _apply_velocity(velocity: Vector2, rotation: float, modifier: str) ###
# Custom function invoked to set walking and direction variables according to a given velocity
# Called from choose_animation()
func _apply_velocity(velocity, rotation, modifier):
	# If the velocity indicates no movement, set walking variable to false
	if velocity.x == 0 and velocity.y == 0: walking = false
	# If the velocity indicates movment, set walking variable to true
	if abs(velocity.x) > 0 or abs(velocity.y) > 0: walking = true
	# Check if the walking variable is true and if the modifier argument is "idle"
	if walking and modifier == "idle":
		# Check if magnitude of the movment in the x axis is greater than the magnitude of the movment in the y axis 
		if abs(velocity.x) > abs(velocity.y):
			# If moving right
			if velocity.x > 0:
				# Set direction variable to "right" and set Sprite2D node's flip_h to true
				direction = "right"
				$Sprite2D.flip_h = true
			# Else if moving left
			elif velocity.x < 0: 
				# Set direction variable to "left" and set Sprite2D node's flip_h to false				
				direction = "left"
				$Sprite2D.flip_h = false
		# Else, check if magnitude of the movment in the y axis is greater than the magnitude of the movment in the x axis 				
		elif abs(velocity.x) < abs(velocity.y):
			# If moving down, set direction variable to "down"
			if velocity.y > 0: direction = "down" 
			# Else if moving up, set direction variable to "up"
			elif velocity.y < 0: direction = "up"
	# If the walking variable is false or the modifier argument is not "idle"
	# invoke _apply_rotation logic passing down the rotation argument
	else: _apply_rotation(rotation)

### _apply_rotation(rotation: float) ###
# Custom function invoked to change the direction based on a given rotation
# Called from _apply_velocity
func _apply_rotation(rotation):
	# set rotation variable as the remaineder of the rotation argument cast into an integer / 360
	rotation = int(rotation) % 360
	# if the rotation variable is less than 0 add 360 to it
	if rotation < 0: rotation += 360
	# 0 degrees is pointing right. Check rotation variable and change the direction variable appropriately
	if rotation > 315 or rotation < 45: direction = "right"
	elif rotation > 45 and rotation < 135: direction = "down"
	elif rotation > 135 and rotation < 225: direction = "left"
	elif rotation > 225 and rotation < 315: direction = "up"
	# If the direction variable is "left" don't flip the Sprite2D
	if direction == "left": $Sprite2D.flip_h = false
	# If the direction variable is "left" flip the Sprite2D
	elif direction == "right": $Sprite2D.flip_h = true
	
### start_flashing() ###
# Custom function invoked to begin the flashing animation
# Called from Player node
func start_flashing():
	# Set flashing variable to true and start FlashTimer
	flashing = true
	$FlashTimer.start()

########################
### Signal Listeners ###
########################

### _on_flash_timer_timeout() ###
# Emitted from FlashTimer node
func _on_flash_timer_timeout():
	# Check if the flashing variable is true
	if flashing:
		# Check if the all_white variable is true
		if all_white:
			# set all_white variable to false and modulate Color to default
			all_white = false
			$Sprite2D.modulate = Color(1,1,1,1)
		# If the all_white variable is false
		else:
			# set all_white variable to true and modulate Color to white
			all_white = true
			$Sprite2D.modulate = Color(10,10,10,10)
	# If the flashing variable is false
	else:
		# Stop the FlashTimer
		$FlashTimer.stop()
		# set all_white variable to false and modulate Color to default
		all_white = false
		$Sprite2D.modulate = Color(1,1,1,1)
