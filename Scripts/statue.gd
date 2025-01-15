extends CharacterBody3D

const SPEED = 3.0
const MAX_SPEED = 3.0  
@export var movement_sound: AudioStreamPlayer3D
@export var detection_area: Area3D  # Assign the Area3D in the Inspector
var can_move = false  # Statue won't move until the player enters the area
var has_been_activated = false  # Prevents re-activation before the player enters the area once
var was_moving = false

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

			# Play sound every time the statue resumes movement
		if velocity != Vector3.ZERO and !was_moving:
			if movement_sound:
				movement_sound.play()
	was_moving = velocity != Vector3.ZERO
		
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
		was_moving = false
		if movement_sound and movement_sound.is_playing():
			movement_sound.stop()
# ✅ Unfreeze Statue (Only When Activated)
func unfreeze_statue():
	if has_been_activated:
		can_move = true
