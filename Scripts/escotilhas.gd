extends Area3D

@export var animation_player_path: NodePath  # Path to the AnimationPlayer node
@export var animation_right: String = "escotilha drt"  # Right hatch animation name
@export var player_group: String = "Player"  # Group name to identify the player
@export var sound_player_path: NodePath  # Path to the AudioStreamPlayer3D node

var animation_player: AnimationPlayer
var sound_player: AudioStreamPlayer3D

func _ready():
	# Cache the AnimationPlayer node
	if animation_player_path:
		animation_player = get_node(animation_player_path)
	else:
		push_error("AnimationPlayer path not set in the Inspector!")

	# Cache the AudioStreamPlayer3D node
	if sound_player_path:
		sound_player = get_node(sound_player_path)
	else:
		push_error("AudioStreamPlayer3D path not set in the Inspector!")
	
	# Connect the body_entered signal
	self.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node):
	# Check if the body belongs to the "Player" group
	if body.is_in_group(player_group):
		if animation_player:
			# Play the hatch animation
			animation_player.play(animation_right)
		if sound_player:
			# Play the hatch sound effect
			sound_player.play()
