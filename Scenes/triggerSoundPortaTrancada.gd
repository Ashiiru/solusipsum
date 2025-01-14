extends Area3D

@export var sound_player: AudioStreamPlayer3D  # Assign your AudioStreamPlayer3D in the Inspector

func _ready():
	# ✅ Connect the signal to trigger sound
	body_entered.connect(_on_area_entered)

func _on_area_entered(body):
	# ✅ Check if the body is the player using groups
	if body.is_in_group("Player"):
		if sound_player:
			sound_player.play()
			print("🎶 Playing Porta Trancada Sound!")
		else:
			print("⚠️ No sound player assigned!")
	else:
		print("⚠️ Non-player body detected:", body.name)
