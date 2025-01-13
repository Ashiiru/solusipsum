extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
const PUSH_FORCE = 1.0
const FOV_ANGLE = 45.0  # ✅ The Field of View angle (Adjust for a wider or narrower view)

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Standard movement and collision logic (unchanged)
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("forward", "down", "right", "left")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	var collision = move_and_slide()

	# ✅ Push RigidBody3D (unchanged)
	if collision:
		for i in range(get_slide_collision_count()):
			var collision_info = get_slide_collision(i)
			var collider = collision_info.get_collider()
			if collider is RigidBody3D and not is_on_floor():
				var push_direction = -collision_info.get_normal()
				push_direction.y = 0
				push_direction = push_direction.normalized()
				collider.apply_impulse(collision_info.get_position(), push_direction * PUSH_FORCE)

	# ✅ Cone Vision Detection (NEW!)
	var statues = get_tree().get_nodes_in_group("Statue")
	var camera_forward = -camera.global_transform.basis.z  # Forward direction of the camera
	var statue_detected = false

	for statue in statues:
		var direction_to_statue = (statue.global_transform.origin - camera.global_transform.origin).normalized()
		var dot_product = camera_forward.dot(direction_to_statue)  # Dot Product Calculation
		var angle_to_statue = rad_to_deg(acos(dot_product))  # Convert to Degrees

		if angle_to_statue < FOV_ANGLE:  # ✅ If statue is in the cone
			statue.freeze_statue()
			statue_detected = true
		else:
			statue.unfreeze_statue()

	# ✅ If no statues are in the FOV, unfreeze them all
	if not statue_detected:
		for statue in statues:
			statue.unfreeze_statue()
