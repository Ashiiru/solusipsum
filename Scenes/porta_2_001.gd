extends MeshInstance3D


@onready var lockedsound: AudioStreamPlayer3D = $CORREDOR__ANDRE/porta2_001/AudioStreamPlayer3D

func play_sound():
	print("sound")
	lockedsound.play()
