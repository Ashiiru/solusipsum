extends StaticBody3D

@export var gate_script_path: NodePath  # Path to the Gate script

var gate_script: Node = null

func _ready():
	# Cache the Gate script
	if gate_script_path:
		gate_script = get_node(gate_script_path)
	else:
		push_error("Gate script path not set!")

func _input_event(InputEventKey):
	if event is InputEventKey:
		if event.pressed and event.button_index == Key_E:
			print("3D Button clicked!")
			if gate_script:
				gate_script._on_button_pressed()  # Trigger the gate's open function
