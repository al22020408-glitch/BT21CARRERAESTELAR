extends Control

# --- REVISIÓN IMPORTANTE ---
@export var escena_proxima = "res://Scenes/SeleccionPersonaje.tscn"

@onready var logo = $vistainicio/icono

var posicion_final_y: float 

func _ready():
	posicion_final_y = logo.position.y
	logo.position.y = -logo.size.y - 100 
	
	iniciar_animacion_caida()
	
	# --- SOLUCIÓN ERROR 1 ---
	# Cambié "_on_timer_timeout" por el nombre exacto de tu función de abajo
	$Timer.timeout.connect(_on_splash_timer_timeout)

func iniciar_animacion_caida():
	var tween = create_tween()
	tween.tween_property(logo, "position:y", posicion_final_y, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_splash_timer_timeout():
	# --- SOLUCIÓN ERROR EXTRA (RUTA DE MÚSICA) ---
	# Tenías una ruta doble (.mp3/.mp3). La corregí a tu archivo de Dynamite:
	var musica_menu = load("res://Audio/musica_fondo.mp3/Dynamite .mp3")
	
	# --- SOLUCIÓN ERROR 2 ---
	# Cambié "MusicaGlobal" por "Musica", que es como se llama tu Autoload actual
	if musica_menu and has_node("/root/Musica"):
		Musica.reproducir_cancion(musica_menu)
	
	# 3. Hacemos el cambio a la escena de selección de personaje
	get_tree().change_scene_to_file(escena_proxima)
