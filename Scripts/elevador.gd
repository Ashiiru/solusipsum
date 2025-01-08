extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_node("AnimationPlayer").play("door_open")
		
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_node("AnimationPlayer").play("door_closed")
