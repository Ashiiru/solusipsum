extends MeshInstance3D

@export var lockedsound: AudioStreamPlayer3D

func play_sound():
	lockedsound.play()
