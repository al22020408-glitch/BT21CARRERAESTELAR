extends Control

# --- CONFIGURACIÓN ---
@export var escena_juego = "res://BT21 CARRERA ESTELAR/Scenes/level1.tscn"

# --- REFERENCIAS A NODOS ---
@onready var boton_jugar = $TextureRect/BotonJugar
@onready var boton_creditos = $TextureRect/BotonCreditos
@onready var boton_salir = $TextureRect/BotonSalir
@onready var boton_silenciar = $TextureRect/BotonSilencio
@onready var press_start = $TextureRect/pressStart
@onready var musica = $AudioStreamPlayer

# --- VARIABLES DE ESTADO ---
var esta_silenciado: bool = false

func _ready():
	# 1. Configuración de Audio Inicial
	if musica:
		musica.volume_db = 0
		if !musica.playing:
			musica.play()

	# 2. Conexión de señales (Botones)
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	boton_silenciar.pressed.connect(_on_silenciar_pressed)
	# Si decides programar créditos luego, descomenta la siguiente línea:
	# boton_creditos.pressed.connect(_on_creditos_pressed)

	# 3. Preparar pivotes para animaciones táctiles
	for b in [boton_jugar, boton_creditos, boton_salir, boton_silenciar]:
		if b: b.pivot_offset = b.size / 2

	# 4. Iniciar animaciones visuales
	animar_press_start()

# --- SISTEMA DE ANIMACIONES ---

func animar_press_start():
	if press_start:
		var tween = create_tween().set_loops()
		tween.tween_property(press_start, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE)
		tween.tween_property(press_start, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE)

func aplicar_efecto_boton(nodo):
	var tw = create_tween()
	tw.tween_property(nodo, "scale", Vector2(0.9, 0.9), 0.1)
	tw.tween_property(nodo, "scale", Vector2.ONE, 0.1)
	return tw

# --- LÓGICA DE LOS BOTONES ---

func _on_jugar_pressed():
	var tw = aplicar_efecto_boton(boton_jugar)
	print("Lead: Iniciando nivel...")
	await tw.finished # Espera a que termine el efecto visual
	
	if FileAccess.file_exists(escena_juego):
		get_tree().change_scene_to_file(escena_juego)
	else:
		printerr("ERROR: No se encuentra la escena en: ", escena_juego)

func _on_silenciar_pressed():
	aplicar_efecto_boton(boton_silenciar)
	esta_silenciado = !esta_silenciado
	
	# Accedemos al Servidor de Audio de Godot
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, esta_silenciado)
	
	# Feedback visual: se pone grisáceo si está muteado
	if esta_silenciado:
		boton_silenciar.modulate = Color(0.5, 0.5, 0.5, 1.0)
		print("Muted")
	else:
		boton_silenciar.modulate = Color(1, 1, 1, 1)
		print("Unmuted")

func _on_salir_pressed():
	aplicar_efecto_boton(boton_salir)
	print("Saliendo del juego...")
	get_tree().quit()
