extends Control

# --- CONFIGURACIÓN ---
@export var escena_al_finalizar = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"
@export var tiempo_de_espera = 3.0

# --- REFERENCIAS A NODOS ---
@onready var texto_cargando = $vistainicio/Label 
@onready var timer = $Timer

func _ready():
	# 1. Verificamos que el nodo exista para evitar errores de 'null instance'
	if texto_cargando:
		iniciar_efecto_latido()
	else:
		push_error("¡Ojo! No se encuentra el nodo 'Label_Cargando'. Revisa el nombre en el árbol.")

	# 2. Configurar y arrancar el Timer
	if timer:
		timer.wait_time = tiempo_de_espera
		timer.one_shot = true
		timer.timeout.connect(_on_tiempo_finalizado)
		timer.start()
	else:
		# Si no tienes un nodo Timer, lo creamos por código
		await get_tree().create_timer(tiempo_de_espera).timeout
		_on_tiempo_finalizado()

func iniciar_efecto_latido():
	# Creamos un Tween que se repite infinitamente
	var tween_latido = create_tween().set_loops()
	
	# PASO A: Desvanecer (Opacidad a 0.2)
	tween_latido.tween_property(texto_cargando, "modulate:a", 0.2, 0.8).set_trans(Tween.TRANS_SINE)
	
	# PASO B: Aparecer (Opacidad a 1.0)
	tween_latido.tween_property(texto_cargando, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE)

func _on_tiempo_finalizado():
	print("Carga finalizada. Cambiando al menú...")
	get_tree().change_scene_to_file(escena_al_finalizar)
