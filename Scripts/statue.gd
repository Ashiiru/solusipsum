extends CharacterBody3D

const SPEED = 3.0
const MAX_SPEED = 3.0  

@export var detection_area: Area3D  # Assign the Area3D in the Inspector
var can_move = false  # Statue won't move until the player enters the area
var has_been_activated = false  # Prevents re-activation before the player enters the area once

func _ready():
	# ✅ Connect the signal for entering the Area3D (Only Entry)
	if detection_area != null:
		detection_area.body_entered.connect(_on_area_entered)
	else:
		print("⚠️ No detection area assigned!")

func _physics_process(delta):
	if not can_move:
		return  # ✅ No movement before activation!

	# ✅ Move towards the player (constant check after activation)
	var players = get_tree().get_nodes_in_group("Player")  # Fetch player from the group
	if players.size() > 0:
		var player = players[0]  # Assuming only one player
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0  # Prevent vertical movement
		velocity = direction * SPEED

		# ✅ Rotate statue to face the player
		if direction.length() > 0:
			var target_position = player.global_transform.origin
			target_position.y = global_transform.origin.y
			look_at(target_position, Vector3.UP)

		# ✅ Stop when close enough
		if global_transform.origin.distance_to(player.global_transform.origin) <= 1.5:
			velocity = Vector3.ZERO
		else:
			velocity = direction * SPEED

		move_and_slide()

# ✅ FIXED: Using Groups to Trigger Activation (No More NodePath Errors!)
func _on_area_entered(body):
	if body.is_in_group("Player") and not has_been_activated:
		has_been_activated = true
		can_move = true
		print("👀 Player entered the area! Statue Activated!")
	else:
		print("⚠️ Non-player body detected:", body.name)

# ✅ Freeze Statue (Only When Activated)
func freeze_statue():
	if has_been_activated:
		can_move = false
		velocity = Vector3.ZERO
		print("❄️ Statue Frozen!")

# ✅ Unfreeze Statue (Only When Activated)
func unfreeze_statue():
	if has_been_activated:
		can_move = true
		print("🏃 Statue Resumed Moving!")
