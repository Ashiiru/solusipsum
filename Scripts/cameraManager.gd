extends Node3D

@export var player_camera_path: NodePath
@export var debug_camera_path: NodePath

var player_camera: Camera3D
var debug_camera: Camera3D

func _ready() -> void:
	# Cache the camera nodes
	player_camera = get_node(player_camera_path)
	debug_camera = get_node(debug_camera_path)

	# Ensure the player camera is the default active camera
	player_camera.current = true
	debug_camera.current = false

func _input(event: InputEvent) -> void:
	# Toggle cameras when a specific key is pressed (e.g., "F1")
	if event.is_action_pressed("ui_debug_camera_toggle"):  # Custom action in Input Map
		if player_camera.current:
			switch_to_debug_camera()
		else:
			switch_to_player_camera()

func switch_to_debug_camera() -> void:
	debug_camera.current = true
	player_camera.current = false
	print("Switched to Debug Camera")

func switch_to_player_camera() -> void:
	player_camera.current = true
	debug_camera.current = false
	print("Switched to Player Camera")


func _on_trigger_anim_down_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
