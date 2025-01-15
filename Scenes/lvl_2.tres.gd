extends Node3D

# ✅ Assign your AnimationPlayer directly in the Inspector!
@export var transition: AnimationPlayer  

func _ready():
	
	# 🎬 Play the FadeIn animation when the scene loads
	if transition and transition.has_animation("FadeIn"):
		transition.play("FadeIn")
		print("🎬 Playing FadeIn on Scene Start!")
	else:
		push_error("🚨 ERROR: AnimationPlayer or 'FadeIn' Animation Not Found!")
