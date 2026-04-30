extends Control

# --- CONFIGURACIÓN ---
@export var escena_juego = "res://BT21 CARRERA ESTELAR/Scenes/level1.tscn"
@export var escena_creditos = "res://BT21 CARRERA ESTELAR/Scenes/creditos.tscn"

# --- REFERENCIAS A NODOS ---
@onready var boton_jugar = $TextureRect/BotonJugar
@onready var boton_creditos = $TextureRect/BotonCreditos
@onready var boton_salir = $TextureRect/BotonSalir
@onready var boton_silenciar = $TextureRect/BotonSilencio
@onready var press_start = $TextureRect/pressStart

# Variable para rastrear el estado del sonido
var esta_silenciado: bool = false

func _ready():
	# Lista de todos los botones para aplicarles efectos automáticamente
	var botones = [boton_jugar, boton_creditos, boton_salir, boton_silenciar]
	
	for btn in botones:
		if btn:
			btn.pivot_offset = btn.size / 2
			btn.mouse_entered.connect(_on_any_button_mouse_entered.bind(btn))
			btn.mouse_exited.connect(_on_any_button_mouse_exited.bind(btn))
	
	# Conexión de funciones principales
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_creditos.pressed.connect(_on_creditos_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	
	# NUEVA CONEXIÓN: Silencio
	if boton_silenciar:
		boton_silenciar.pressed.connect(_on_silenciar_pressed)
	
	animar_press_start()

# --- EFECTOS GENERALES ---

func _on_any_button_mouse_entered(btn):
	var tw = create_tween().set_parallel(true)
	tw.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1)
	tw.tween_property(btn, "modulate", Color(1.2, 1.2, 1.2), 0.1)

func _on_any_button_mouse_exited(btn):
	var tw = create_tween().set_parallel(true)
	tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	# Si está silenciado, mantenemos el color grisáceo al salir el mouse
	if btn == boton_silenciar and esta_silenciado:
		tw.tween_property(btn, "modulate", Color(0.5, 0.5, 0.5), 0.1)
	else:
		tw.tween_property(btn, "modulate", Color.WHITE, 0.1)

func aplicar_efecto_clic(btn):
	var tw = create_tween()
	tw.tween_property(btn, "scale", Vector2(0.8, 0.8), 0.05)
	tw.tween_property(btn, "scale", Vector2.ONE, 0.05)
	return tw

# --- LÓGICA DE BOTONES ---

func _on_silenciar_pressed():
	aplicar_efecto_clic(boton_silenciar)
	esta_silenciado = !esta_silenciado
	
	# Buscamos el bus principal de audio (Master) y lo muteamos
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, esta_silenciado)
	
	# Feedback visual: El botón se pone oscuro si está silenciado
	if esta_silenciado:
		boton_silenciar.modulate = Color(0.5, 0.5, 0.5)
		print("Audio Silenciado")
	else:
		boton_silenciar.modulate = Color.WHITE
		print("Audio Activado")

func _on_jugar_pressed():
	await aplicar_efecto_clic(boton_jugar).finished
	get_tree().change_scene_to_file(escena_juego)

func _on_creditos_pressed():
	await aplicar_efecto_clic(boton_creditos).finished
	get_tree().change_scene_to_file(escena_creditos)

func _on_salir_pressed():
	await aplicar_efecto_clic(boton_salir).finished
	get_tree().quit()

func animar_press_start():
	if press_start:
		var tween = create_tween().set_loops()
		tween.tween_property(press_start, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE)
		tween.tween_property(press_start, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE)
