extends KinematicBody

var velocity : Vector3 = Vector3()
var limits : float = 0

func _physics_process(delta: float) -> void:
	limits += 0.1
	velocity.z = -limits
	velocity.y = limits
	
	if limits > 5:
		limits =- limits
	
	rotation_degrees.x -= deg2rad(12)
	
	
	print(transform.basis)
	
	move_and_slide(velocity, Vector3.UP)
