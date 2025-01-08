extends Node3D  # Attach this script to the character's head node

@export var player_head_path: NodePath  # Path to the player's head node (assign in the editor)

var player_head: Node3D = null

func _ready():
	if player_head_path:
		player_head = get_node(player_head_path)

func _process(delta):
	if player_head:
		look_at(player_head.global_transform.origin, Vector3.UP)
