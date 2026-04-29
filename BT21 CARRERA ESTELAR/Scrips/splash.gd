extends Control

# Ruta de la escena del menú
@export var escena_menu = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"

# Referencia actualizada al nuevo nombre del nodo
@onready var label_cargando = $Fondo/LabelCargando

func _ready():
	# Centramos el pivote para que el efecto de escala sea desde el medio del texto
	label_cargando.pivot_offset = label_cargando.size / 2
	
	# Iniciamos el efecto de "respiración"
	iniciar_efecto_cargando()
	
	# Conectamos el Timer
	$Timer.timeout.connect(_on_timer_timeout)

func iniciar_efecto_cargando():
	var tween = create_tween().set_loops()
	
	# Efecto de latido suave (crece y encoge)
	tween.tween_property(label_cargando, "scale", Vector2(1.1, 1.1), 0.8).set_trans(Tween.TRANS_SINE)
	tween.tween_property(label_cargando, "scale", Vector2(1.0, 1.0), 0.8).set_trans(Tween.TRANS_SINE)
	
	# PLUS: Vamos a hacer que el texto parpadee un poco (opacidad) para que parezca más "Cargando"
	tween.parallel().tween_property(label_cargando, "modulate:a", 0.6, 0.8)
	tween.parallel().tween_property(label_cargando, "modulate:a", 1.0, 0.8)

func _on_timer_timeout():
	get_tree().change_scene_to_file(escena_menu)
