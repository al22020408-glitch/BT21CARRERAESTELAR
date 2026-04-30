extends Control

# --- CONFIGURACIÓN ---
# Ruta de la escena a la que iremos automáticamente
@export var escena_al_finalizar = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"
# Tiempo en segundos que durará la pantalla de carga
@export var tiempo_de_carga = 3.0 

# --- REFERENCIAS ---
# Referencia al texto o logo que va a parpadear (tu nodo Label)
@onready var texto_cargando = $vistainicio/Label

func _ready():
	# 1. Iniciamos el efecto de parpadeo (latido)
	iniciar_efecto_latido()
	
	# 2. Creamos un temporizador rápido por código para el cambio de escena.
	# Así no dependemos obligatoriamente de tener el nodo Timer en la escena.
	get_tree().create_timer(tiempo_de_carga).timeout.connect(_on_tiempo_finalizado)

func iniciar_efecto_latido():
	# Verificamos que el nodo exista para evitar errores
	if not texto_cargando:
		push_error("¡Ojo! No se encuentra el nodo 'Label' en '$vistainicio/Label'")
		return

	# Creamos un Tween que se repite infinitamente
	var tween_latido = create_tween().set_loops()
	
	# -- PASO A (Desvanecer) --
	# Baja la opacidad (Modulate.a) a 0.2 (casi transparente) en 0.8 segundos
	tween_latido.tween_property(texto_cargando, "modulate:a", 0.2, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# -- PASO B (Aparecer) --
	# Sube la opacidad de vuelta a 1.0 (totalmente visible) en 0.8 segundos
	tween_latido.tween_property(texto_cargando, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_tiempo_finalizado():
	# Esta función se ejecuta automáticamente cuando pasan los 3 segundos
	print("Carga finalizada. Cambiando al menú...")
	get_tree().change_scene_to_file(escena_al_finalizar)
