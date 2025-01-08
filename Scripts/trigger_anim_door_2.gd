extends Area3D

@onready var animation_player = $"../Trigger_Anim_Door/AnimationPlayer"



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
<<<<<<< Updated upstream:Scripts/trigger_anim_door_2.gd
		animation_player.play("door_open")
=======
		animation_player.play("AnimationPlayer").play("door_open")
>>>>>>> Stashed changes:Scenes/trigger_anim_door_2.gd
		print("Porta Abriu Baixo")
