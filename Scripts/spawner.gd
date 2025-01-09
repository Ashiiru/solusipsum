extends Node3D

@export var sphere_scene: PackedScene      # arraste "Sphere.tscn" aqui
@export var spawn_interval: float = 1.0    # tempo em segundos entre cada spawn
@export var spawn_position_node: NodePath  # referencie um nó (Node3D) que define a posição

func _ready() -> void:
	# Cria um Timer para spawnar a cada 'spawn_interval' segundos
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(timer)

func _on_spawn_timer_timeout() -> void:
	# Instancia a esfera
	if sphere_scene:
		var sphere_instance = sphere_scene.instantiate()

		# Pega a posição de spawn (por ex. um marcador no mapa)
		var position_node = get_node(spawn_position_node) if spawn_position_node != null else self
		sphere_instance.transform.origin = position_node.transform.origin

		# Adiciona a esfera à cena, de preferência no mesmo nível em que o Spawner está
		get_parent().add_child(sphere_instance)
	else:
		push_warning("sphere_scene não está configurada no Inspector!")
