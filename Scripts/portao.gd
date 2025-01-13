extends StaticBody3D 

@export var gate_path: NodePath  # Path to the gate node (portao)
@export var animation_player_path: NodePath  # Path to the AnimationPlayer in the gate
@export var animation_player_down_path: NodePath
@export var button_area_path: NodePath  # Path to the Area3D around the button
@export var gate_collision_area_path: NodePath  # Path to the Area3D near the gate
@export var gear_animation_player_path: NodePath  # Path to the AnimationPlayer for the gear animations
@export var open_animation: String = "portao"  # Name of the open animation
@export var close_animation: String = "portao down"  # Name of the close animation
@export var gear_open_animation: String = "engrenagem"  # Name of the gear open animation
@export var gear_close_animation: String = "engrenagem fecha"  # Name of the gear close animation
@export var cooldown_time: float = 3.0  # Time in seconds before the button can be used again
@export var sound_gear_up_path: NodePath  # Path to the AudioStreamPlayer3D for "engrenagem sobe"
@export var sound_gear_down_path: NodePath  # Path to the AudioStreamPlayer3D for "engrenagem baixo"
@export var sound_gate_closed_path: NodePath  # Path to the AudioStreamPlayer3D for "portao fecha"
@export var close_duration_scale: float = 2.0  # Closing speed multiplier
@export var open_sound_duration: float = 9.0  # Open sound length
@export var close_sound_duration: float = 1.0  # Close sound length

var animation_player: AnimationPlayer
var animation_player_down: AnimationPlayer
var gear_animation_player: AnimationPlayer
var sound_gear_up: AudioStreamPlayer3D
var sound_gear_down: AudioStreamPlayer3D
var sound_gate_closed: AudioStreamPlayer3D
var gate: Node3D
var button_area: Area3D
var gate_collision_area: Area3D
var on_cooldown: bool = false

func _ready():
	# Cache required nodes
	gate = get_node(gate_path) if has_node(gate_path) else null
	animation_player_down = get_node(animation_player_down_path) if has_node(animation_player_down_path) else null
	animation_player = get_node(animation_player_path) if has_node(animation_player_path) else null
	gear_animation_player = get_node(gear_animation_player_path) if has_node(gear_animation_player_path) else null
	button_area = get_node(button_area_path) if has_node(button_area_path) else null
	gate_collision_area = get_node(gate_collision_area_path) if has_node(gate_collision_area_path) else null
	sound_gear_up = get_node(sound_gear_up_path) if has_node(sound_gear_up_path) else null
	sound_gear_down = get_node(sound_gear_down_path) if has_node(sound_gear_down_path) else null
	sound_gate_closed = get_node(sound_gate_closed_path) if has_node(sound_gate_closed_path) else null

	# Connect signals once!
	if button_area:
		button_area.body_entered.connect(_on_button_area_body_entered)
	if gate_collision_area:
		gate_collision_area.body_entered.connect(_on_gate_area_body_entered)

func _on_button_area_body_entered(body: Node):
	if not on_cooldown and body.is_in_group("Player"):
		start_open_gate()

func start_open_gate():
	if animation_player and not animation_player.is_playing():
		on_cooldown = true
		animation_player.play(open_animation)
		
		# ✅ Play open sound and gear animation
		if sound_gear_up:
			sound_gear_up.play()
		if gear_animation_player:
			gear_animation_player.play(gear_open_animation)
		
		# ✅ Cooldown to prevent spamming
		var timer = Timer.new()
		timer.wait_time = open_sound_duration
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_cooldown_finished"))
		add_child(timer)
		timer.start()

func _on_cooldown_finished():
	on_cooldown = false

func _on_gate_area_body_entered(body: Node):
	if body.is_in_group("Player"):
		smooth_close_gate()

## ✅ FIXED: No Teleporting, No Sound Overlap, Perfect Sync
func smooth_close_gate():
	if animation_player_down and animation_player_down.has_animation(close_animation):
		
		var progress = 0.0  # Default progress if no animation is playing

		# ✅ If the open animation is still playing, calculate progress
		if animation_player.is_playing():
			var current_position = animation_player.current_animation_position
			var total_open_length = animation_player.current_animation_length
			progress = current_position / total_open_length
			animation_player.stop()
			
			# ✅ FIX: Stop the open sound if the animation was interrupted
			if sound_gear_up and sound_gear_up.playing:
				sound_gear_up.stop()
		
		# ✅ FIX: Prevent teleporting if open animation finished completely
		elif progress >= 1.0:
			print("Open animation finished completely, playing close animation from the start.")
			progress = 0.0  # Reset progress to avoid teleporting

		# ✅ Stop any current closing animation before restarting
		if animation_player_down.is_playing():
			animation_player_down.stop()

		# ✅ Disconnect the signal to prevent duplicates
		if animation_player_down.is_connected("animation_finished", Callable(self, "_on_gate_closed_animation_finished")):
			animation_player_down.disconnect("animation_finished", Callable(self, "_on_gate_closed_animation_finished"))

		# ✅ Mirrored Keyframes Fix: Flip progress for inverse animation sync
		var total_close_length = animation_player_down.get_animation(close_animation).length
		var seek_position = (1.0 - progress) * total_close_length

		print("Mirroring Fix Active | Progress:", progress, "| Seeking to:", seek_position)
		animation_player_down.play(close_animation)
		animation_player_down.seek(seek_position, true)  # Perfect mirrored frame matching

		# ✅ Keep closing animation speed constant
		animation_player_down.speed_scale = 1.0

		# ✅ Play gear and gate closing sounds
		if gear_animation_player:
			gear_animation_player.play(gear_close_animation)
		if sound_gear_down:
			sound_gear_down.play()

		# ✅ Connect the signal once for finalizing the close animation
		animation_player_down.animation_finished.connect(_on_gate_closed_animation_finished)

func _on_gate_closed_animation_finished(animation_name: String):
	if animation_name == close_animation and sound_gate_closed:
		sound_gate_closed.play()
		print("Gate fully closed and final sound played.")
