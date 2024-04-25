extends CharacterBody2D

#################
### Variables ###
#################

# Variable that holds a reference to the parent world node
# Set from _ready
# Object
var world

# Variable that holds an integer that determines the player's speed
# int
var speed = 80

var talking = false

##########################
### Built in Functions ###
##########################

### _ready() ###
# Invoked when node is first instantiated.
func _ready():
	# assign parent node to world variable
	world = get_parent()
	world.player = self
	_set_scale(1.5)

### _physics_process(delta: float) ###
# Invoked every frame 
func _physics_process(delta):
	# invoke handle_movement passing down the delta argument
	handle_movement(delta)
	# invoke choose_animation logic
	choose_animation()

########################
### Custom Functions ###
########################

### add_body_to_world(body) ###
# Custom function invoked to add a body to the current game world's scene tree
# Called from _ready, shoot, _on_mob_spawn_path_add_mob_to_world
func add_body_to_world(body):
	world.add_child(body)

func _set_scale(incoming_scale):
	var new_scale = Vector2(incoming_scale, incoming_scale)
	$CollisionShape2D.apply_scale(new_scale)
	$PlayerSkinSelector.get_node("Sprite2D").apply_scale(new_scale)

### handle_movement(delta) ###
# Custom function invoked to listen for player input and move the Player node
# Called from _physics_process
func handle_movement(delta):
	# Reset Velocity every frame
	velocity = Vector2.ZERO
	# Listen for input in Y-Axis. Assign it to variable vertical_axis
	var vertical_axis = Input.get_axis("move_up", "move_down")	
	# Listen for input in X-Axis. Assign it to variable horizontal_axis
	var horizontal_axis = Input.get_axis("move_left","move_right")	
	if not talking:
		# Set Velocity Vectors with player input
		velocity.y += vertical_axis
		velocity.x += horizontal_axis
		$Rotation.look_at(get_global_mouse_position())
	# Apply speed to velocity vector and normalize Velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	# Apply velocity to position
	position += velocity * delta
	# Apply rotation

### choose_animation() ###
# Custom function invoked to choose an animation based on player action and play it
# Called from _physics_process
func choose_animation():
	# assign "idle" into modifier variable
	var modifier = "idle"
	# invoke choose_animation logic on PlayerSkinSelector node passing velocity, Rotation node's rotation, and modifier as the arguments
	$PlayerSkinSelector.choose_animation(velocity, $Rotation.rotation_degrees, modifier)


