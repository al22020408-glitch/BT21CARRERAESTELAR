extends Control

@export var escena_menu = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"

# Asegúrate de que el nombre sea $botonBack exactamente como en tu escena
@onready var boton_back = $botonBack

func _ready():
	if boton_back:
		# 1. Ajustar el pivote al centro para que el efecto de escala no se mueva a una esquina
		boton_back.pivot_offset = boton_back.size / 2
		
		# 2. Conectar señales para efectos de mouse
		boton_back.pressed.connect(_on_back_pressed)
		boton_back.mouse_entered.connect(_on_mouse_entered)
		boton_back.mouse_exited.connect(_on_mouse_exited)

func _on_back_pressed():
	# Efecto de "Hundirse" y volver
	var tw = create_tween()
	# Se hace pequeño (0.8) y vuelve a su tamaño normal muy rápido
	tw.tween_property(boton_back, "scale", Vector2(0.8, 0.8), 0.05)
	tw.tween_property(boton_back, "scale", Vector2.ONE, 0.05)
	
	await tw.finished
	get_tree().change_scene_to_file(escena_menu)

func _on_mouse_entered():
	# Efecto cuando el mouse está encima: se agranda un poquito y brilla
	var tw = create_tween()
	tw.set_parallel(true) # Hace ambas cosas al mismo tiempo
	tw.tween_property(boton_back, "scale", Vector2(1.1, 1.1), 0.1)
	tw.tween_property(boton_back, "modulate", Color(1.2, 1.2, 1.2), 0.1) # Brillo ligero

func _on_mouse_exited():
	# Vuelve a la normalidad cuando quitas el mouse
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(boton_back, "scale", Vector2.ONE, 0.1)
	tw.tween_property(boton_back, "modulate", Color.WHITE, 0.1)
