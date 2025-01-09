extends StaticBody3D 

@export var gate_path: NodePath  # Path to the gate node (portao)
@export var animation_player_path: NodePath  # Path to the AnimationPlayer in the gate
@export var animation_player_down_path: NodePath
@export var button_area_path: NodePath  # Path to the Area3D around the button
@export var gate_collision_area_path: NodePath  # Path to the Area3D near the gate
@export var open_animation: String = "portao"  # Name of the open animation
@export var close_animation: String = "portao down"  # Name of the close animation
@export var cooldown_time: float = 3.0  # Time in seconds before the button can be used again

var animation_player: AnimationPlayer
var animation_player_down: AnimationPlayer
var gate: Node3D
var button_area: Area3D
var gate_collision_area: Area3D
var on_cooldown: bool = false

func _ready():
	# Cache required nodes
	if gate_path:
		gate = get_node(gate_path)
	else:
		push_error("Gate path not set!")
	if animation_player_down_path:
		animation_player_down = get_node(animation_player_down_path)
	else:
		push_error("AnimationPlayerDown path not set!")
		
	if animation_player_path:
		animation_player = get_node(animation_player_path)
	else:
		push_error("AnimationPlayer path not set!")
	
	if button_area_path:
		button_area = get_node(button_area_path)
		button_area.body_entered.connect(_on_button_area_body_entered)
	else:
		push_error("Button Area path not set!")
	
	if gate_collision_area_path:
		gate_collision_area = get_node(gate_collision_area_path)
		gate_collision_area.body_entered.connect(_on_gate_area_body_entered)
	else:
		push_error("Gate Collision Area path not set!")

func _on_button_area_body_entered(body: Node):
	if not on_cooldown and body.is_in_group("Player"):  # Ensure it's the player
		start_open_gate()

func start_open_gate():
	if animation_player and animation_player.is_playing():
		# Prevent opening if the gate is already closing
		if animation_player.current_animation == close_animation:
			return

	on_cooldown = true
	animation_player.play(open_animation)
	print("Gate is opening.")
	
	# Start cooldown timer
	var timer = Timer.new()
	timer.wait_time = cooldown_time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_cooldown_finished"))
	add_child(timer)
	timer.start()

func _on_cooldown_finished():
	on_cooldown = false

func _on_gate_area_body_entered(body: Node):
	if body.is_in_group("Player"):  # Ensure it's the player
		if animation_player_down:
			animation_player_down.play(close_animation)
			print("Gate is closing.")
