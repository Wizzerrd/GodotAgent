extends Node2D

#################
### Variables ###
#################

# Variable that holds a boolean indicating whether or not the mob is walking
# Set in _apply_velocity()
# bool
var walking = false

# Variable that holds a string indicating which direction the mob is facing
# Set in apply_velocity()
# str
var direction = "down"

# Variable that holds a string indicating which animation is currently playing
# Set in choose_animation()
# str
var current_animation = ""

########################
### Custom Functions ###
########################

### choose_type(incoming_type: str) ###
# Custom function invoked to set the texture of Sprite2D node
# Called from BasicMob node
func choose_type(incoming_type):
	# Set the path variable to a string interpolated with the incoming_type argument
	var path = "res://art/%s.png" % incoming_type
	# Set Sprite2D node's texture to the result of loading the path variable	
	$Sprite2D.texture = load(path)
	$Sprite2D.apply_scale(Vector2(1.5,1.5))

### choose_animation(velocity: Vector2, incoming_modifier: str) ###
# Custom function invoked to choose the proper animation according to incoming parameters
# Called from Player node
func choose_animation(velocity, rotation):
	# invoke _apply_velocity logic passing velocity parameter normalized down
	_apply_velocity(velocity.normalized(), rotation)
	# assign new variable new_animation to an empty string
	var new_animation = ""
	# If the walking variable is true, start new_animation with "walking_"
	if walking: new_animation += "walking_"
	# If the walking variable is false, start new_animation with "standing_"
	else: new_animation += "standing_"
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
func _apply_velocity(velocity, rotation):
	# If the velocity indicates no movement, set walking variable to false
	if velocity.x == 0 and velocity.y == 0: walking = false
	# If the velocity indicates movment, set walking variable to true
	if abs(velocity.x) > 0 or abs(velocity.y) > 0: walking = true
	# Check if the walking variable is true and if the modifier argument is "idle"
	if walking:
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
	
### die() ###
# Custom function invoked to clear status shader and stop the animation
# Called from BasicMob node
func die():
	# modulate color to default
	$Sprite2D.modulate = Color(1,1,1,1)
	# Stop AnimationPlayer's animation from playing
	$AnimationPlayer.stop()
	
### reanimate(incoming_tome: int) ###
# Custom function invoked to modulate color to based on incoming tome
# Called from BasicMob node
func reanimate(incoming_tome):
	# Start AnimationPlayer's animation
	$AnimationPlayer.play()
	# TEMPORARY - If incoming_tome < 0 modulate color to Blue
	if incoming_tome: $Sprite2D.modulate = Color(5,1,5,0.9)
	# TEMPORARY - Else if incoming tome > 0 modulate color to Purple
	else: $Sprite2D.modulate = Color(1,1,5,0.9)
	
### cleanse(incoming_holy: int) ###
# Custom function invoked to modulate color based on incoming_holy
# Called from BasicMob node
func cleanse(incoming_holy):
	$Sprite2D.modulate = Color(1.5,2,1,1)


