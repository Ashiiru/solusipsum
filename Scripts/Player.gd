extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
const PUSH_FORCE = 1.0  # Force applied when pushing rigid bodies

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide the cursor

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# 1) Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y -= 9.8 * delta  # Standard gravity

	# 2) Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3) Movement (horizontal)
	var input_dir := Input.get_vector("forward", "down", "right", "left")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	# 4) Move the character and check for collisions
	var collision = move_and_slide()

	# 5) Push RigidBody3D when colliding (this is the part you asked for)
	if collision:
		for i in range(get_slide_collision_count()):
			var collision_info = get_slide_collision(i)
			var collider = collision_info.get_collider()
			
			# Ensure the collider is a RigidBody3D and not treated as the floor
			if collider is RigidBody3D and not is_on_floor():
				var push_direction = -collision_info.get_normal()
				push_direction.y = 0  # Ignore vertical force
				push_direction = push_direction.normalized()
				
				# Apply the push force
				collider.apply_impulse(collision_info.get_position(), push_direction * PUSH_FORCE)
