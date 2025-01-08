extends Area3D

@export var animation_player_path: NodePath  # Path to the AnimationPlayer node
@export var player_group: String = "Player"  # Group name to check for the player
@export var open_animation: String = "door_open"  # Name of the "open" animation
@export var close_animation: String = "door_close"  # Name of the "close" animation

var animation_player: AnimationPlayer

func _ready() -> void:
	# Cache the AnimationPlayer node
	if animation_player_path != null:  # Check if the NodePath is set
		animation_player = get_node(animation_player_path)
	else:
		push_error("AnimationPlayer path is not set in the Inspector!")

func _on_body_entered(body: Node3D) -> void:
	print("body_entered called")
	if body.is_in_group(player_group):
		if animation_player:
			animation_player.play(open_animation)
			print("Porta Abriu")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(player_group):
		if animation_player:
			animation_player.play(close_animation)
			print("Porta Fechou")
