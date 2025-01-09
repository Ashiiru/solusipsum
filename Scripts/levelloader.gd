extends Area3D

@export var next_level_path: String = "res://levels/next_level.tscn"
@export var trigger_by_player: bool = true  
@export var trigger_by_ball: bool = true  

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Body entered: ", body.name)

	if (trigger_by_player and body.is_in_group("Player")):
		print("Player Triggered the Level Loader")
		# Use call_deferred() to safely change the level
		call_deferred("_change_scene")

	elif (trigger_by_ball and body.is_in_group("Ball")):
		print("Sphere Triggered the Level Loader")
		call_deferred("_change_scene")

	else:
		print("No valid trigger detected for this body.")

# New function for level changing (called after physics step)
func _change_scene():
	get_tree().change_scene_to_file(next_level_path)
