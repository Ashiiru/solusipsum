extends Area3D

@onready var animation_player = $"../Trigger_Anim_Door/AnimationPlayer2"
@onready var move_sound = $"../../Corredor_Afonso_v3/elevador/elevador move"  # Moving sound
@onready var end_sound = $"../../Corredor_Afonso_v3/elevador/elevador sino"  # Ending sound
var has_played: bool = false  # Ensure the sequence runs only once

func _ready() -> void:
	# Debugging logs
	print("Elevator system initialized.")
	if not animation_player:
		print("Error: AnimationPlayer not found!")
	if not move_sound:
		print("Error: Move sound 'elevador move' not found!")
	if not end_sound:
		print("Error: End sound 'elevador sino' not found!")

	# Connect animation_finished signal
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not has_played:
		if animation_player:
			animation_player.play("elevador_baixo")
			print("Playing animation 'elevador_baixo'")
		if move_sound:
			move_sound.play()
			print("Playing move sound 'elevador move'")
		has_played = true

func _on_animation_finished(animation_name: String) -> void:
	print("Animation finished:", animation_name)
	if animation_name == "elevador_baixo":  # Ensure it's the correct animation
		if end_sound:
			end_sound.play()
			print("Playing end sound 'elevador sino'")



		

		
		
	
	
