extends Area3D

@export var locked_sound_path: NodePath  # Path to the AudioStreamPlayer3D node for the locked door sound
@export var player_group: String = "Player"  # Group name for the player detection

var locked_sound: AudioStreamPlayer3D

func _ready() -> void:
	# Cache the AudioStreamPlayer3D node
	if not locked_sound_path.is_empty():
		locked_sound = get_node(locked_sound_path)
	else:
		push_error("Locked sound path is not set in the Inspector!")

	# Ensure the body entered signal is connected
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Check if the entering body is part of the player group
	if body.is_in_group(player_group):
		if locked_sound:
			locked_sound.play()
			print("Porta Trancada!")
		else:
			push_error("Locked sound node not found!")
