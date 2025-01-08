extends Node3D

@export var animation_player_path: NodePath  # Path to the AnimationPlayer node
@export var open_animation: String = "portao cima"  # Name of the "open gate" animation
@export var close_animation: String = "portao baixo"  # Name of the "close gate" animation
@export var area_path: NodePath  # Path to the Area3D node for player detection
@export var button_path: NodePath  # Path to the Button node
@export var player_group: String = "Player"  # Group name for the player

var animation_player: AnimationPlayer
var area: Area3D
var button: Button

func _ready() -> void:
	# Cache nodes
	if animation_player_path != null:
		animation_player = get_node(animation_player_path)
	else:
		push_error("AnimationPlayer path is not set!")

	if area_path != null:
		area = get_node(area_path)
		# Connect signals for Area3D
		area.connect("body_entered", self, "_on_area_body_entered")
	else:
		push_error("Area3D path is not set!")

	if button_path != null:
		button = get_node(button_path)
		# Connect signal for Button
		button.connect("pressed", self, "_on_button_pressed")
	else:
		push_error("Button path is not set!")

func _on_button_pressed() -> void:
	# Play the open animation when the button is clicked
	if animation_player:
		animation_player.play(open_animation)
		print("Gate opening animation played.")

func _on_area_body_entered(body: Node) -> void:
	# Check if the body entering the area belongs to the player group
	if body.is_in_group(player_group):
		if animation_player:
			animation_player.play(close_animation)
			print("Gate closing animation played.")



func _on_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
