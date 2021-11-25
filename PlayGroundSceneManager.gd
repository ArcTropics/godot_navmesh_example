extends Spatial

export(NodePath) onready var player = get_node(player) 
export(NodePath) onready var go_panel = get_node(go_panel)
export(NodePath) onready var go_btn = get_node(go_btn)
export(NodePath) onready var exit_area = get_node(exit_area)


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Exit_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		go_btn.text = "YOU WON!"
		go_panel.visible = true
		get_tree().paused = true
		
func _on_ActivationArea_body_entered(body: Node) -> void:
	exit_area.visible = true
	exit_area.get_node("CollisionShape").disabled = false
