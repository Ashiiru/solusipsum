extends Node3D

@onready var transition = $LevelLoader/CollisionShape3D/CanvasLayer/AnimationPlayerFade

func _ready():transition.play("FadeIn")
