extends KinematicBody

export(float) var move_speed : float = 5
export(float) var threshold : float = 5
export(float) var time : float = 1
export(float) var rotation_speed : float = 5
 
var path := []
var current_path_index : int = 0
var target = null
var velocity : Vector3 = Vector3.ZERO
var is_following : bool = false
var panel = null
var exit = null

onready var nav : Navigation = get_parent()
onready var timer = get_node("TimerStart")
onready var timer_fail = get_node("TimerFail")
onready var raycast = get_node("RayCast")


func _ready() -> void:
	yield(owner, "ready")
	target = owner.player
	timer.wait_time = time
	owner.get_node("ActivationArea").connect("body_entered", self, "_on_Activation_area_body_entered")
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer_fail.connect("timeout", self, "_on_TimerFail_timeout")
	
	panel = owner.get_node("GameOverPanel")
	
	

func _process(delta: float) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == target:
			print("Gotcha Buddy!")
			get_tree().paused = true
			panel.visible = true
			

func _physics_process(delta: float) -> void:
	if path.size() > 0:
		move_to_target()
		
	if is_following:
		raycast.enabled = true
		var enemy_heading_2d : Vector2 = Vector2(transform.basis.z.x, transform.basis.z.z)
		var dir = -target.transform.origin + transform.origin
		var desired_heading_2d : Vector2 = Vector2(dir.x, dir.z)
		var phi = desired_heading_2d.angle_to(enemy_heading_2d)
		phi = phi * delta * rotation_speed
		if (phi < .01):
			phi = 0
			look_at(target.transform.origin, Vector3.UP)
			rotation.x = 0
			
		else:
			rotation.y += phi
		
		if global_transform.origin.distance_to(target.transform.origin) < threshold:
			timer_fail.stop()

func move_to_target() -> void:	
	if global_transform.origin.distance_to(path[current_path_index]) < threshold:
		path.remove(0)
	else:
		var direction = path[current_path_index] - global_transform.origin
		velocity = direction.normalized() * move_speed
		move_and_slide(velocity, Vector3.UP)

func get_target_path() -> void:
	activate_bots()

func activate_bots():
	
	timer.start()
	is_following = true
	path =  nav.get_simple_path(global_transform.origin, target.global_transform.origin)

func deactivate_bots():
	return
	timer.stop()
	is_following = false
	path.empty()


func _on_Timer_timeout() -> void:
	get_target_path()


func _on_Activation_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		timer_fail.start()
		activate_bots()
		owner.get_node("ActivationArea/Fireball").queue_free()
		

func _on_TimerFail_timeout() -> void:
	deactivate_bots()
	
func _restart_game():
	get_tree().reload_current_scene()
