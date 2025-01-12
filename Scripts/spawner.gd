extends Node3D

@export var sphere_scene: PackedScene      # arraste "Sphere.tscn" aqui
@export var spawn_interval: float = 1.0    # tempo entre cada spawn
@export var spawn_position_node: NodePath  # nó que define a posição de spawn
@export var trigger_area: NodePath         # Área3D que ativa o spawn

var timer: Timer = null
var spawning_active: bool = false  # Controla o estado do spawn

func _ready() -> void:
	# Cria o Timer, mas NÃO começa automaticamente
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(timer)

	# Conecta a Área3D para ativar o spawn e verifica se o nó existe
	if trigger_area != null and has_node(trigger_area):
		var area = get_node(trigger_area)
		area.connect("body_entered", Callable(self, "_on_player_entered"))
	else:
		push_warning("Trigger area não foi configurada corretamente!")

func _on_player_entered(body):
	# Debug para checar se o corpo foi detectado
	print("Player entered area: ", body.name)

	# Inicia o Timer apenas quando o jogador entrar na Área3D
	if body.is_in_group("Player") and not spawning_active:
		spawning_active = true
		timer.start()
		print("Timer iniciado!")  # Debug para confirmar que o Timer iniciou

func _on_spawn_timer_timeout() -> void:
	# Instancia a esfera apenas quando ativado
	if sphere_scene:
		var sphere_instance = sphere_scene.instantiate()

		# Verifica se o nó de posição está definido
		if has_node(spawn_position_node):
			var position_node = get_node(spawn_position_node)
			sphere_instance.transform.origin = position_node.transform.origin
		else:
			sphere_instance.transform.origin = self.transform.origin
			push_warning("spawn_position_node não foi configurado corretamente!")

		# Adiciona a esfera à cena e confirma via debug
		get_parent().add_child(sphere_instance)
		print("Esfera spawnada!")
	else:
		push_warning("sphere_scene não está configurada no Inspector!")
