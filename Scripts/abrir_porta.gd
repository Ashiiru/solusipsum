extends Area3D

@export var animation_player_path: NodePath  # Path to the AnimationPlayer node
@export var player_group: String = "Player"  # Group name to check for the player
@export var open_animation: String = "open door"  # Name of the "open" animation
@export var close_animation: String = "close door"  # Name of the "close" animation
@export var open_sound_path: NodePath  # Path to the AudioStreamPlayer3D for the open sound
@export var close_sound_path: NodePath  # Path to the AudioStreamPlayer3D for the close sound

var animation_player: AnimationPlayer
var open_sound: AudioStreamPlayer3D
var close_sound: AudioStreamPlayer3D
var is_playing_animation: bool = false

func _ready() -> void:
	# Cache the AnimationPlayer node
	if animation_player_path != null:  # Check if the NodePath is set
		animation_player = get_node(animation_player_path)
		animation_player.animation_finished.connect(_on_animation_finished)
	else:
		push_error("AnimationPlayer path is not set in the Inspector!")

	# Cache the AudioStreamPlayer3D nodes
	if open_sound_path != null:
		open_sound = get_node(open_sound_path)
	else:
		push_error("Open sound path not set!")

	if close_sound_path != null:
		close_sound = get_node(close_sound_path)
	else:
		push_error("Close sound path not set!")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(player_group) and not is_playing_animation:
		play_animation(open_animation)
		if open_sound:
			open_sound.play()
		print("Porta Abriu")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(player_group) and not is_playing_animation:
		play_animation(close_animation)
		if close_sound:
			close_sound.play()
		print("Porta Fechou")

func play_animation(animation_name: String) -> void:
	if animation_player and not animation_player.is_playing():
		animation_player.play(animation_name)
		is_playing_animation = true

func _on_animation_finished(animation_name: String) -> void:
	# Mark the animation as finished
	is_playing_animation = false
