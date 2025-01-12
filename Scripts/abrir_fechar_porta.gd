extends Area3D

@export var animation_player_path: NodePath  # Path to the AnimationPlayer node
@export var open_sound_path: NodePath  # Path to the AudioStreamPlayer3D for opening sound
@export var close_sound_path: NodePath  # Path to the AudioStreamPlayer3D for closing sound
@export var player_group: String = "Player"  # Group name to check for the player
@export var open_animation: String = "door_open"  # Name of the "open" animation
@export var close_animation: String = "door_closed"  # Name of the "close" animation

var animation_player: AnimationPlayer
var open_sound: AudioStreamPlayer3D
var close_sound: AudioStreamPlayer3D
var is_playing_animation: bool = false  # Tracks if an animation is currently playing
var pending_animation: String = ""  # Stores any pending animation

func _ready() -> void:
	# Cache the AnimationPlayer node
	if animation_player_path:
		animation_player = get_node(animation_player_path)
		animation_player.animation_finished.connect(_on_animation_finished)
	else:
		push_error("AnimationPlayer path is not set in the Inspector!")
	
	# Cache the AudioStreamPlayer3D nodes
	if open_sound_path:
		open_sound = get_node(open_sound_path)
	else:
		push_error("Open sound path is not set!")
	
	if close_sound_path:
		close_sound = get_node(close_sound_path)
	else:
		push_error("Close sound path is not set!")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(player_group) and not is_playing_animation:
		play_animation(open_animation)
		if open_sound:
			open_sound.play()
	elif body.is_in_group(player_group):
		pending_animation = open_animation

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(player_group) and not is_playing_animation:
		play_animation(close_animation)
		if close_sound:
			close_sound.play()
	elif body.is_in_group(player_group):
		pending_animation = close_animation

func play_animation(animation_name: String) -> void:
	if animation_player and not is_playing_animation:
		is_playing_animation = true
		animation_player.play(animation_name)

func _on_animation_finished(anim_name: String) -> void:
	is_playing_animation = false
	if pending_animation != "":
		var next_animation = pending_animation
		pending_animation = ""
		play_animation(next_animation)
