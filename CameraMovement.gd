extends Camera

export(NodePath) onready var target = get_node(target)
export(Resource) var setup

var _pressed : bool = false
var _last_touched_pos : Vector2  

func _ready() -> void:
	if setup.target_offset == Vector3.ZERO:
		setup.target_offset = self.transform.origin - target.transform.origin - setup.anchor_offset

	if setup.look_target == Vector3.ZERO:
		setup.look_target = Vector3(0.0, 0.0, 100.0)

	setup.pitch_limit.x = deg2rad(setup.pitch_limit.x)
	setup.pitch_limit.y = deg2rad(setup.pitch_limit.y)
	setup.rotation.x = deg2rad(setup.rotation.x)
	setup.rotation.y = deg2rad(setup.rotation.y)
	setup.rotation.z = deg2rad(setup.rotation.z)
	


func _process(delta: float) -> void:
	self.transform.origin = target.transform.origin + setup.anchor_offset
	var target_offset = setup.target_offset
	var look_at = setup.look_target
	var up_down_axis = Vector3.RIGHT.rotated(Vector3.UP, setup.rotation.y)
	target_offset = target_offset.rotated(Vector3.UP, setup.rotation.y)
	look_at = look_at.rotated(Vector3.UP, setup.rotation.y )
	
	target_offset = target_offset.rotated(up_down_axis, setup.rotation.x )
	look_at = look_at.rotated(up_down_axis, setup.rotation.x)

	self.transform.origin + target_offset
	self.look_at(look_at, Vector3.UP)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed == true:
		if _pressed == false:
			_pressed = true
			_last_touched_pos = event.position

	if event is InputEventScreenTouch and event.pressed == false:
		_pressed = false

	if event is InputEventScreenDrag and _pressed:
			var diff : Vector2 = _last_touched_pos - event.position
			print(diff)
			diff = diff / 300
			setup.rotation.y += diff.x
			setup.rotation.x += diff.y
			setup.rotation.x = clamp(setup.rotation.x, setup.pitch_limit.x, setup.pitch_limit.y)

			_last_touched_pos = event.position
