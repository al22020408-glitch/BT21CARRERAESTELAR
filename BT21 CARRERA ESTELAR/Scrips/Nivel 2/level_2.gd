extends Node2D

# --- PREFABS ---
var escenas_frutas = [
	preload("res://BT21 CARRERA ESTELAR/Prefabs/manzana.tscn"),
	preload("res://BT21 CARRERA ESTELAR/Prefabs/platano.tscn"),
	preload("res://BT21 CARRERA ESTELAR/Prefabs/Fresa.tscn"),
	preload("res://BT21 CARRERA ESTELAR/Prefabs/dorada.tscn")
]


@onready var contenedor = $ContenedorFrutas
@onready var personaje = $CharacterBody2D
@onready var label_puntos = $CanvasLayer/LabelPuntos
@onready var label_tiempo = $CanvasLayer/LabelTiempo

# --- VARIABLES DE CONTROL ---
var meta_puntos = 1000 # Actualizado a la meta real del juego
var ultima_posicion_x = 0.0
var distancia_minima = 470.0 
var estrella_aparecida = false # Control para no crear múltiples estrellas

func _ready():
	PuntosGlobales.resetear_para_reintentar()
	
	if label_puntos:
		label_puntos.text = "PUNTOS: 0"
		
	personaje.z_index = 10 
	
	cambiar_musica_nivel("res://BT21 CARRERA ESTELAR/Audio/musica_fondo.mp3/Butter.mp3")
	
	if has_node("GeneradorTimer"):
		$GeneradorTimer.timeout.connect(_on_generador_timer_timeout)
		$GeneradorTimer.start()
		
	if has_node("TimerLluvia"):
		$TimerLluvia.timeout.connect(_on_lluvia_frutas_timeout)
		$TimerLluvia.start()

func _process(_delta):
	if label_puntos:
		label_puntos.text = "PUNTOS: " + str(PuntosGlobales.puntos)
	if label_tiempo:
		label_tiempo.text = "TIEMPO: " + str(int(PuntosGlobales.tiempo_restante))


func finalizar_partida():
	# Si el tiempo llega a 0 y el jugador no ha tocado la estrella, pierde una vida
	PuntosGlobales.nivel_terminado = true
	PuntosGlobales.puntos_ultima_partida = PuntosGlobales.puntos
	PuntosGlobales.vidas -= 1
	get_tree().change_scene_to_file("res://BT21 CARRERA ESTELAR/Scenes/loser_screen.level1.tscn")

# --- LÓGICA DE GENERACIÓN ---

func _on_generador_timer_timeout():
	# Si ya apareció la estrella, dejamos de generar obstáculos para que el camino esté despejado
	if estrella_aparecida: 
		return
		
	ultima_posicion_x = personaje.global_position.x + randf_range(500, 800)
	var suerte_global = randi() % 100
	if suerte_global < 35:
		generar_patron_obstaculos(ultima_posicion_x)
	else:
		generar_fruta_normal(ultima_posicion_x)

func generar_patron_obstaculos(pos_x):
	var patron = randi() % 5 
	var suelo_y = 790 
	var lodo_y = 720
	var alto_caja = 70 
	var ancho_caja = 65

	

func generar_fruta_normal(pos_x):
	var suerte = randi() % 100
	var fruta_escena
	if suerte < 5: fruta_escena = escenas_frutas[3]
	elif suerte < 40: fruta_escena = escenas_frutas[2]
	elif suerte < 70: fruta_escena = escenas_frutas[1]
	else: fruta_escena = escenas_frutas[0]

	var fruta = fruta_escena.instantiate()
	fruta.z_index = 9
	fruta.global_position = Vector2(pos_x, randf_range(500.0, 680.0))
	contenedor.add_child(fruta)

func instanciar_objeto(escena, posicion):
	var obj = escena.instantiate()
	obj.global_position = posicion
	obj.z_index = 5 
	contenedor.add_child(obj)

func _on_lluvia_frutas_timeout():
	if estrella_aparecida: return # Detener lluvia al final
	
	var fruta_cae = escenas_frutas[randi() % 3].instantiate()
	fruta_cae.z_index = 9
	var pos_x = personaje.global_position.x + randf_range(200, 500)
	var pos_y = personaje.global_position.y - 600
	fruta_cae.global_position = Vector2(pos_x, pos_y)
	contenedor.add_child(fruta_cae)
	var tween = create_tween()
	tween.tween_property(fruta_cae, "position:y", 720, 2.2).set_trans(Tween.TRANS_LINEAR)

func cambiar_musica_nivel(ruta_nueva):
	var repro = get_node_or_null("/root/Musica")
	if repro:
		# --- AJUSTE DE VOLUMEN ---
		# -10.0 es un volumen moderado, -20.0 es más bajo.
		repro.volume_db = -20.0 
		
		var nueva_cancion = load(ruta_nueva)
		if repro.stream != nueva_cancion:
			repro.stream = nueva_cancion
			repro.play()
