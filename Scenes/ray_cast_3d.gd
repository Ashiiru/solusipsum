extends RayCast3D

func _ready():
	add_exception(owner)
	
	
func _physics_process(_delta):
	if is_colliding():
		print("skibidi")
