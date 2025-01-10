extends CharacterBody3D

const SPEED = 3.0
const MAX_SPEED = 3.0  

@export var player: Node3D  # ✅ Player is now set manually in the Inspector
var can_move = true  # Statue can move initially

func _physics_process(delta):
	# ✅ Prevent errors if player is not assigned in the Inspector
	if player == null:
		print("⚠️ Player not assigned in the Inspector!")
		return

	# ✅ Move only if allowed
	if can_move:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0  # Prevent vertical movement
		velocity = direction * SPEED

		# ✅ Stop moving if too close
		if global_transform.origin.distance_to(player.global_transform.origin) > 1.5:
			if test_move(global_transform, direction * SPEED * delta):
				velocity = Vector3.ZERO
			else:
				velocity = direction * SPEED
		else:
			velocity = Vector3.ZERO  # Stop when near the player

		# ✅ Apply movement with physics
		move_and_slide()

# ✅ Called when the player looks at the statue (FREEZES)
func freeze_statue():
	can_move = false
	velocity = Vector3.ZERO
	print("❄️ Statue Frozen!")

# ✅ Called when the player looks away (MOVES AGAIN)
func unfreeze_statue():
	can_move = true
	print("🏃 Statue Resumed Moving!")
