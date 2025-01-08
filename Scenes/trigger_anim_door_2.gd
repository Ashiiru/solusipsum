extends Area3D

@onready var animation_player = $"../Trigger_Anim_Door/AnimationPlayer"



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_node("AnimationPlayer").play("door_open")
		print("Porta Abriu Baixo")
