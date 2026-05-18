extends Control



# --- CONFIGURACIÓN ---
# Verifica que esta ruta sea exacta haciendo clic derecho en el archivo y "Copiar Ruta"
@export var escena_juego = "res://BT21 CARRERA ESTELAR/Scenes/nivel2/level_2.tscn"
#@export var escena_creditos = "res://BT21 CARRERA ESTELAR/Scenes/creditos.tscn"

# --- REFERENCIAS A NODOS ---
@onready var boton_jugar = $TextureRect/BotonJugar
@onready var boton_salir = $TextureRect/BotonSalir
@onready var boton_silenciar = $TextureRect/BotonSilencio
@onready var press_start = $TextureRect/pressStart
#@onready var musica = $AudioStreamPlayer

# --- VARIABLES DE ESTADO ---
var esta_silenciado: bool = false

func _ready():
	
	# 1. Configuración de Audio mediante el Autoload
	reproducir_musica_menu()

	# 2. Conexión de señales (Mantenemos tu lógica actual)
	if !boton_jugar.pressed.is_connected(_on_jugar_pressed):
		boton_jugar.pressed.connect(_on_jugar_pressed)
	
	if !boton_salir.pressed.is_connected(_on_salir_pressed):
		boton_salir.pressed.connect(_on_salir_pressed)
	
	# ... otras conexiones ...
	if !boton_silenciar.pressed.is_connected(_on_boton_silencio_pressed):
		boton_silenciar.pressed.connect(_on_boton_silencio_pressed)

	# 3. Preparar pivotes
	for b in [boton_jugar, boton_salir, boton_silenciar]:
		if b: b.pivot_offset = b.size / 2

	animar_press_start()

# Nueva función para controlar la música del Autoload
func reproducir_musica_menu():
	# Accedemos al nodo 'ReproductorMusica' dentro de nuestro Autoload 'Musica'
	var repro = get_node_or_null("/root/Musica/ReproductorMusica")
	
	if repro:
		# Ruta de la canción del menú (asegúrate que sea la correcta)
		var cancion_menu = load("res://BT21 CARRERA ESTELAR/Audio/musica_menu.mp3")
		
		# Solo cambiamos la música si NO es la que ya se está reproduciendo
		# Esto evita que se reinicie al pasar del menú 1 al menú 2
		if repro.stream != cancion_menu:
			repro.stream = cancion_menu
			repro.volume_db = -10.0 # Ajusta el volumen a tu gusto
			repro.play()

# --- ANIMACIONES ---

func animar_press_start():
	if press_start:
		var tween = create_tween().set_loops()
		tween.tween_property(press_start, "modulate:a", 0.0, 0.8)
		tween.tween_property(press_start, "modulate:a", 1.0, 0.8)

func aplicar_efecto_boton(nodo):
	var tw = create_tween()
	tw.tween_property(nodo, "scale", Vector2(0.9, 0.9), 0.1)
	tw.tween_property(nodo, "scale", Vector2.ONE, 0.1)
	return tw

# --- LÓGICA DE BOTONES ---

func _on_jugar_pressed():
	var tw = aplicar_efecto_boton(boton_jugar)
	await tw.finished 
	if FileAccess.file_exists(escena_juego):
		get_tree().change_scene_to_file(escena_juego)

func _on_boton_silencio_pressed():
	aplicar_efecto_boton(boton_silenciar)
	esta_silenciado = !esta_silenciado
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), esta_silenciado)
	boton_silenciar.modulate = Color(0.5, 0.5, 0.5, 1) if esta_silenciado else Color(1, 1, 1, 1)

func _on_salir_pressed():
	aplicar_efecto_boton(boton_salir)
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
