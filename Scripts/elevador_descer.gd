extends Area3D

@onready var animation_player = $"../Trigger_Anim_Door/AnimationPlayer"
var has_played: bool = false  # To ensure the sequence runs only once

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not has_played:
		
		animation_player.play("elevador_baixo")
		
		print("Elevador Desceu")
		has_played = true  # Prevent re-triggering
		

		
		
	
	
