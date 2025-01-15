extends Area3D

@export var next_level_path: String = "res://levels/next_level.tscn"
@export var trigger_by_player: bool = true  
@export var trigger_by_ball: bool = true  
@export var trigger_by_statue: bool = true
@export var animation_player: AnimationPlayer  # Drag your AnimationPlayer here in Inspector!

var is_transitioning = false  # Prevents multiple triggers
var next_scene: PackedScene  # Preloaded scene for smoother transitions

func _ready():
	# ✅ Preload the next level for instant switching (no black frames)
	next_scene = ResourceLoader.load(next_level_path)
	if next_scene == null:
		push_error("🚨 ERROR: Failed to preload the next level! Check the path!")

	# ✅ Automatically play FadeIn when the scene starts
	if animation_player and animation_player.has_animation("FadeIn"):
		animation_player.play("FadeIn")
	else:
		push_error("🚨 ERROR: AnimationPlayer not set correctly!")
		return

	connect("body_entered", _on_body_entered)
	print("🎬 Level loaded, waiting for trigger!")

# 🎯 **Trigger the Fade Out + Scene Change (Strict Trigger Filtering)**
func _on_body_entered(body):
	if is_transitioning:
		print("⚠️ Already transitioning!")
		return  

	# ✅ Prevent triggering on non-specified objects
	if body != null and not (
		(trigger_by_player and body.is_in_group("Player")) or
		(trigger_by_ball and body.is_in_group("Ball")) or
		(trigger_by_statue and body.is_in_group("Statue"))
	):
		print("🚧 Ignoring non-trigger body:", body.name)
		return

	if animation_player == null:
		push_error("🚨 ERROR: AnimationPlayer not found!")
		return

	is_transitioning = true  

	# ✅ Trigger based on body groups
	if trigger_by_player and body.is_in_group("Player"):
		print("🎮 Player Triggered!")
		_start_fade()

	elif trigger_by_ball and body.is_in_group("Ball"):
		print("🏀 Ball Triggered!")
		_start_fade()

	elif trigger_by_statue and body.is_in_group("Statue"):
		print("🗿 Statue Triggered!")
		_start_fade()

# 🎬 **Fade Out Before Changing Scene**
func _start_fade():
	print("🎬 Playing FadeOut...")
	animation_player.play("FadeOut")
	await animation_player.animation_finished
	call_deferred("_change_scene")

# 🚀 **Scene Change with Proper Loading**
func _change_scene():
	print("🌌 Switching Scene to:", next_level_path)

	# ✅ Using the preloaded scene to avoid loading lag
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)
		print("✅ Scene Loaded! Playing FadeIn...")
		animation_player.play("FadeIn")
		await animation_player.animation_finished
		is_transitioning = false
	else:
		push_error("🚨 ERROR: Preloaded scene is null! Check your path!")
		is_transitioning = false
