extends Control

# --- CONFIGURACIÓN ---
# Verifica que esta ruta sea exacta haciendo clic derecho en el archivo y "Copiar Ruta"
@export var escena_juego = "res://Scenes/level1.tscn"
@export var escena_creditos = "res://Scenes/creditos.tscn"

# --- REFERENCIAS A NODOS ---
@onready var boton_jugar = $TextureRect/BotonJugar
@onready var boton_creditos = $TextureRect/BotonCreditos
@onready var boton_salir = $TextureRect/BotonSalir
@onready var boton_silenciar = $TextureRect/BotonSilencio
@onready var press_start = $TextureRect/pressStart

# --- VARIABLES DE ESTADO ---
var esta_silenciado: bool = false

func _ready():

	# 2. Conexión de señales (Todas por código para evitar errores)
	if !boton_jugar.pressed.is_connected(_on_jugar_pressed):
		boton_jugar.pressed.connect(_on_jugar_pressed)
	
	if !boton_salir.pressed.is_connected(_on_salir_pressed):
		boton_salir.pressed.connect(_on_salir_pressed)
	
	if !boton_silenciar.pressed.is_connected(_on_silenciar_pressed):
		boton_silenciar.pressed.connect(_on_silenciar_pressed)
	
	if !boton_creditos.pressed.is_connected(_on_boton_creditos_pressed):
		boton_creditos.pressed.connect(_on_boton_creditos_pressed)

	# 3. Preparar pivotes
	for b in [boton_jugar, boton_creditos, boton_salir, boton_silenciar]:
		if b: b.pivot_offset = b.size / 2

	animar_press_start()

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

func _on_boton_creditos_pressed():
	var tw = aplicar_efecto_boton(boton_creditos)
	await tw.finished
	if FileAccess.file_exists(escena_creditos):
		get_tree().change_scene_to_file(escena_creditos)

func _on_silenciar_pressed():
	# Le decimos al script global que alterne el silencio
	var esta_pausado = Musica.alternar_silencio()
	
	# Cambiamos el color del botón basándonos en la respuesta
	if esta_pausado:
		$TextureRect/BotonSilencio.modulate = Color(0.5, 0.5, 0.5) # Gris
	else:
		$TextureRect/BotonSilencio.modulate = Color.WHITE # Normal

func _on_salir_pressed():
	aplicar_efecto_boton(boton_salir)
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
