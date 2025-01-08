extends Area3D

@onready var animation_player = $"../Trigger_Anim_Door/AnimationPlayer"
var has_played_2: bool = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not has_played_2:
		has_played_2 = true
		animation_player.play("door_open")
		
