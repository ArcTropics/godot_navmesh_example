extends Camera

export(NodePath) onready var target = get_node(target)
export(Resource) var setup
export(float) var rotation_speed : float = 10 
export(float) var mouse_sensitivity : float = 2
var _pressed : bool = false
var _last_touched_pos : Vector2  

func _ready() -> void:
	setup.pitch_limit.x = deg2rad(setup.pitch_limit.x)
	setup.pitch_limit.y = deg2rad(setup.pitch_limit.y)
	setup.rotation.x = deg2rad(setup.rotation.x)
	setup.rotation.y = deg2rad(setup.rotation.y)
	setup.rotation.z = deg2rad(setup.rotation.z)


func _process(delta: float) -> void:
	
	transform.origin = target.transform.origin + setup.anchor_offset
	var target_offset : Vector3 = setup.target_offset
	var look_at : Vector3 = setup.look_target
	var up_down_axis : Vector3 = Vector3.RIGHT.rotated(Vector3.UP, setup.rotation.y)
# Make Y axis rotations first
	target_offset = target_offset.rotated(Vector3.UP, setup.rotation.y)
	look_at = look_at.rotated(Vector3.UP, setup.rotation.y)
# Make x axis rotations
	target_offset = target_offset.rotated(up_down_axis, setup.rotation.x)
	look_at = look_at.rotated(up_down_axis, setup.rotation.x)
# Now apply transform
	transform.origin += target_offset
# And now make camera look at the target look at.
	look_at(look_at, Vector3.UP)
# Check if something is in between camera and target
	collision_detection()

#	FOR MOUSE INPUT ONLY. USE THE SECOND OPTION FOR TOUCH SCREEN
#func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion and event.button_mask == 1:
#		setup.rotation.y -= event.relative.x / get_viewport().size.x * mouse_sensitivity
#		setup.rotation.x -= event.relative.y / get_viewport().size.y * mouse_sensitivity

# FOR TOUCH SCREEN
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed == true:
		if _pressed == false:
			_pressed = true
			_last_touched_pos = event.position

	if event is InputEventScreenTouch and event.pressed == false:
		_pressed = false

	if event is InputEventScreenDrag and _pressed:
			var diff : Vector2 = _last_touched_pos - event.position
			diff = diff / 300
			setup.rotation.y += diff.x
			setup.rotation.x += diff.y
			setup.rotation.x = clamp(setup.rotation.x, setup.pitch_limit.x, setup.pitch_limit.y)

			_last_touched_pos = event.position


func collision_detection():
	var start : Vector3 = target.transform.origin + setup.anchor_offset
	var end : Vector3 = self.transform.origin
	var space_state = get_world().direct_space_state
	var col = space_state.intersect_ray(start, end)
	
	if not col.empty():
		self.transform.origin = col.position
