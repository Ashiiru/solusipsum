extends Area3D

@export var luz_corredor_som: AudioStreamPlayer3D
@export var transition_time: float = 0.5  # Time for smooth transition

var target_volume_db := 0.0
var current_volume_db := 0.0
var target_lowpass_cutoff := 20000  # Max frequency (no muffling)
var current_lowpass_cutoff := 20000
var lowpass_filter: AudioEffectLowPassFilter

func _ready():
	# Ensure audio player is assigned correctly
	if luz_corredor_som == null:
		push_error("AudioStreamPlayer3D for 'luz corredor som' not assigned!")
		return

	# Assign to a specific bus where only this sound exists
	luz_corredor_som.bus = "MuffledBus"

	# Create a dedicated lowpass filter effect (independent for this sound)
	lowpass_filter = AudioEffectLowPassFilter.new()
	lowpass_filter.cutoff_hz = current_lowpass_cutoff

	# Attach the filter only to the specific sound bus if not already added
	var bus_idx = AudioServer.get_bus_index("MuffledBus")
	if AudioServer.get_bus_effect_count(bus_idx) == 0:
		AudioServer.add_bus_effect(bus_idx, lowpass_filter)

	# Connect signals for Area3D detection
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _process(delta):
	# Smooth transitions for the specific sound
	current_volume_db = lerp(current_volume_db, target_volume_db, delta / transition_time)
	current_lowpass_cutoff = lerp(current_lowpass_cutoff, target_lowpass_cutoff, delta / transition_time)

	# Apply the effect directly to "luz corredor som" only
	luz_corredor_som.volume_db = current_volume_db

	# Modify the lowpass effect directly for this sound
	var bus_idx = AudioServer.get_bus_index("MuffledBus")
	var filter_effect = AudioServer.get_bus_effect(bus_idx, 0) as AudioEffectLowPassFilter
	if filter_effect:
		filter_effect.cutoff_hz = current_lowpass_cutoff

func _on_body_entered(body):
	# If the player enters the area, muffle the sound
	if body.is_in_group("Player"):
		target_volume_db = -20
		target_lowpass_cutoff = 1000  # More muffled

func _on_body_exited(body):
	# If the player exits, restore the normal sound
	if body.is_in_group("Player"):
		target_volume_db = 0
		target_lowpass_cutoff = 20000  # Full clarity
