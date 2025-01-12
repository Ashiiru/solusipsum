extends Area3D

@export var audio_player: AudioStreamPlayer3D
@export var transition_time: float = 0.5  # Time for smooth transition
var target_volume_db := 0.0
var current_volume_db := 0.0
var target_lowpass_cutoff := 20000  # Max frequency (no muffling)
var current_lowpass_cutoff := 20000
var lowpass_filter: AudioEffectLowPassFilter

func _ready():
	# Assign the player to its own bus for isolated control
	audio_player.bus = "MuffledBus"
	
	# Get the index of the specific bus
	var bus_idx = AudioServer.get_bus_index(audio_player.bus)

	# Check and add the lowpass filter only on this bus
	if AudioServer.get_bus_effect_count(bus_idx) == 0:
		lowpass_filter = AudioEffectLowPassFilter.new()
		AudioServer.add_bus_effect(bus_idx, lowpass_filter)
	else:
		lowpass_filter = AudioServer.get_bus_effect(bus_idx, 0) as AudioEffectLowPassFilter

	# Connect signals properly
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _process(delta):
	# Smooth transitions
	current_volume_db = lerp(current_volume_db, target_volume_db, delta / transition_time)
	current_lowpass_cutoff = lerp(current_lowpass_cutoff, target_lowpass_cutoff, delta / transition_time)
	
	# Apply the smooth effect to the isolated bus only
	audio_player.volume_db = current_volume_db
	if lowpass_filter:
		lowpass_filter.cutoff_hz = current_lowpass_cutoff

func _on_body_entered(body):
	if body.is_in_group("Player"):
		target_volume_db = -20
		target_lowpass_cutoff = 1000

func _on_body_exited(body):
	if body.is_in_group("Player"):
		target_volume_db = 0
		target_lowpass_cutoff = 20000
