extends Area3D

@export var animation_player_path: NodePath  # Path to the AnimationPlayer node
@export var player_group: String = "Player"  # Group name to check for the player
@export var open_animation: String = "open door"  # Name of the "open" animation
@export var close_animation: String = "close door"  # Name of the "close" animation

var animation_player: AnimationPlayer
var is_playing_animation: bool = false

func _ready() -> void:
	# Cache the AnimationPlayer node
	if animation_player_path != null:  # Check if the NodePath is set
		animation_player = get_node(animation_player_path)
		animation_player.animation_finished.connect(_on_animation_finished)
	else:
		push_error("AnimationPlayer path is not set in the Inspector!")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(player_group) and not is_playing_animation:
		play_animation(open_animation)
		print("Porta Abriu")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(player_group) and not is_playing_animation:
		play_animation(close_animation)
		print("Porta Fechou")

func play_animation(animation_name: String) -> void:
	if animation_player and not animation_player.is_playing():
		animation_player.play(animation_name)
		is_playing_animation = true

func _on_animation_finished(animation_name: String) -> void:
	# Mark the animation as finished
	is_playing_animation = false
