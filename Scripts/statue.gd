extends CharacterBody3D

const SPEED = 3.0
const MAX_SPEED = 3.0  

@export var player: Node3D  # Player set manually in the Inspector
@export var detection_area: Area3D  # Assign the Area3D in the Inspector
var can_move = false  # Statue won't move until the player enters the area

func _ready():
	# ✅ Connect the signals for entering and exiting the Area3D
	if detection_area != null:
		detection_area.body_entered.connect(_on_area_entered)
		detection_area.body_exited.connect(_on_area_exited)
	else:
		print("⚠️ No detection area assigned!")

func _physics_process(delta):
	# Prevent errors if player is not assigned in the Inspector
	if player == null:
		print("⚠️ Player not assigned in the Inspector!")
		return

	# Move only if allowed and inside the detection area
	if can_move:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0  # Prevent vertical movement
		velocity = direction * SPEED

		# ✅ Rotate the statue towards the player
		if direction.length() > 0:
			var target_position = player.global_transform.origin
			target_position.y = global_transform.origin.y
			look_at(target_position, Vector3.UP)

		# Stop moving if too close
		if global_transform.origin.distance_to(player.global_transform.origin) > 1.5:
			if test_move(global_transform, direction * SPEED * delta):
				velocity = Vector3.ZERO
			else:
				velocity = direction * SPEED
		else:
			velocity = Vector3.ZERO  # Stop when near the player

		# Apply movement with physics
		move_and_slide()

# ✅ Trigger when player enters the detection area
func _on_area_entered(body):
	if body == player:
		print("👀 Player entered the area!")
		can_move = true

# ✅ Trigger when player exits the detection area
func _on_area_exited(body):
	if body == player:
		print("🚫 Player exited the area!")
		can_move = false
		velocity = Vector3.ZERO

# Called when the player looks at the statue (FREEZES)
func freeze_statue():
	can_move = false
	velocity = Vector3.ZERO
	print("❄️ Statue Frozen!")

# Called when the player looks away (MOVES AGAIN)
func unfreeze_statue():
	can_move = true
	print("🏃 Statue Resumed Moving!")
