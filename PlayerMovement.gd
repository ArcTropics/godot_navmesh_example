extends KinematicBody

export(float) var move_speed : float = 10
export(float) var rotation_speed : float = 20
export(float) var gravity : float = .98

export(NodePath) onready var camera = get_node(camera)

var velocity : Vector3 = Vector3()
var y_velocity : float = 0

func _physics_process(delta) -> void:
	# Get directionfrom Inputs
	
	var dir : Vector3 = _get_direction()
	
	if dir.length_squared() > 0.01:
		velocity = Vector3.FORWARD * move_speed 
#		velocity.x = dir.x * move_speed
		
		dir = dir.rotated(Vector3.UP, camera.setup.rotation.y)
		
		var player_heading_2d := Vector2(self.transform.basis.z.x, self.transform.basis.z.z)
		var desired_heading_2d := Vector2(dir.x, dir.z)
		
		var phi = desired_heading_2d.angle_to(player_heading_2d)
		phi = phi * delta * rotation_speed
		self.rotation.y += phi 
		
		velocity = velocity.rotated(Vector3.UP, self.rotation.y)
	else:
		velocity = Vector3.ZERO
		velocity = velocity.rotated(Vector3.UP, self.rotation.y)
	
	# Apply gravity
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity -= gravity

	velocity.y = y_velocity

#	Move and Slide the Player
	move_and_slide(velocity, Vector3.UP)

func _unhandled_input(event):
	pass

func _get_direction() -> Vector3:
	var dir : Vector3 = Vector3()
# FOU JOYSTICK INPUT
	dir.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	dir.x = -Input.get_action_strength("move_right") + Input.get_action_strength("move_left")

# FOR KEYBOARD INPUT ONLY. USE ABOVE FOR JOYSTICK INPUT
#	if (Input.is_action_pressed("move_forward")):
#		dir.z += 1.0
#	if (Input.is_action_pressed("move_backward")):
#		dir.z -= 1.0
#	if (Input.is_action_pressed("move_left")):
#		dir.x += 1.0
#	if (Input.is_action_pressed("move_right")):
#		dir.x -= 1.0
		
	return dir

