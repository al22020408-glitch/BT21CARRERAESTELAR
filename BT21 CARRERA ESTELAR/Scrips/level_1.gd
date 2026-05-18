extends Node2D

# --- PREFABS ---
var escenas_frutas = [
	preload("res://BT21 CARRERA ESTELAR/Prefabs/manzana.tscn"),
	preload("res://BT21 CARRERA ESTELAR/Prefabs/platano.tscn"),
	preload("res://BT21 CARRERA ESTELAR/Prefabs/Fresa.tscn"),
	preload("res://BT21 CARRERA ESTELAR/Prefabs/dorada.tscn")
]

var escena_caja = preload("res://BT21 CARRERA ESTELAR/Prefabs/caja.tscn")
var escena_lodo = preload("res://BT21 CARRERA ESTELAR/Prefabs/lodo.tscn")
var escena_cesta = preload("res://BT21 CARRERA ESTELAR/Prefabs/cesta.tscn")

# NUEVO: Prefab de la estrella de victoria
var escena_estrella = preload("res://BT21 CARRERA ESTELAR/Prefabs/EstrellaFinal.tscn")

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
	
	cambiar_musica_nivel("res://BT21 CARRERA ESTELAR/Audio/musica_fondo.mp3/A Brand New Day (8-Bit Computer Game Cover Version of BTS & Zara Larsson).mp3")
	
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

	# --- LÓGICA DE LA ESTRELLA ---
	# Si llegamos a la meta y la estrella aún no está en el nivel
	if PuntosGlobales.puntos >= meta_puntos and not estrella_aparecida:
		aparecer_estrella_victoria()

	# Si el tiempo se acaba, disparamos el final
	if PuntosGlobales.tiempo_restante <= 0 and not PuntosGlobales.nivel_terminado:
		finalizar_partida()

func aparecer_estrella_victoria():
	estrella_aparecida = true
	var pos_x = personaje.global_position.x + 700
	var suelo_y = 790
	var alto_caja = 70
	
	# --- EL CAMBIO ESTÁ AQUÍ ---
	# Creamos la estrella 150 píxeles MÁS A LA DERECHA que las cajas
	var estrella = escena_estrella.instantiate()
	estrella.global_position = Vector2(pos_x + 150, suelo_y - (alto_caja * 3.5))
	estrella.z_index = 15
	add_child(estrella)
	
	# Las cajas se quedan en la posición original (pos_x)
	instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y))
	instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y - alto_caja))
	
	print("¡Escalera lista! Salta desde la segunda caja para alcanzar la estrella.")

func finalizar_partida():
	# Si el tiempo llega a 0 y el jugador no ha tocado la estrella, pierde una vida
	PuntosGlobales.nivel_terminado = true
	PuntosGlobales.puntos_ultima_partida = PuntosGlobales.puntos
	PuntosGlobales.vidas -= 1
	get_tree().change_scene_to_file("res://BT21 CARRERA ESTELAR/Scenes/loser_screen.level1.tscn")

# --- LÓGICA DE GENERACIÓN ---

# Variable global al inicio del script
var proxima_posicion_disponible = 0.0

func _on_generador_timer_timeout():
	if estrella_aparecida: return
	
	# Distancia mínima que quieres entre grupos de cajas
	var distancia_entre_grupos = 450.0 
	
	# Calculamos dónde ponerlo: la última posición + el margen de seguridad
	var pos_x = proxima_posicion_disponible + distancia_entre_grupos + randf_range(0, 200)
	
	# Si el personaje se quedó atrás, ajustamos para que no aparezcan cosas muy lejos
	if pos_x < personaje.global_position.x + 600:
		pos_x = personaje.global_position.x + 800

	var suerte = randi() % 100
	if suerte < 35:
		# Guardamos el ancho que ocupó el patrón para que el siguiente no se encime
		var ancho_usado = generar_patron_obstaculos(pos_x)
		proxima_posicion_disponible = pos_x + ancho_usado
	else:
		generar_fruta_normal(pos_x)
		proxima_posicion_disponible = pos_x + 50 # Las frutas ocupan poco espacio

func generar_patron_obstaculos(pos_x) -> float:
	var patron = randi() % 5 
	var suelo_y = 790 
	var lodo_y = 720
	var alto_caja = 70 
	var ancho_caja = 65
	
	# Variable para medir cuánto espacio horizontal ocupó este grupo
	var ancho_ocupado = ancho_caja 

	match patron:
		0: # Lodo
			var lodo = escena_lodo.instantiate()
			lodo.global_position = Vector2(pos_x, lodo_y)
			lodo.z_index = -5
			contenedor.add_child(lodo)
			ancho_ocupado = 150 # El lodo suele ser más ancho que una caja

		1: # Caja sola
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y))

		2: # Torre + Cesta
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y))
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y - alto_caja))
			instanciar_objeto(escena_cesta, Vector2(pos_x, suelo_y - (alto_caja * 2)))

		3: # Escalera L + Dorada
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y)) 
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y - alto_caja))
			# Esta caja está a la derecha, por lo que este patrón es más ancho
			instanciar_objeto(escena_caja, Vector2(pos_x + ancho_caja, suelo_y))
			
			var dorada = escenas_frutas[3].instantiate()
			dorada.global_position = Vector2(pos_x, suelo_y - (alto_caja * 2))
			dorada.z_index = 9
			contenedor.add_child(dorada)
			ancho_ocupado = ancho_caja * 2 # Ocupa dos cajas de ancho

		4: # Torre + Manzana
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y))
			instanciar_objeto(escena_caja, Vector2(pos_x, suelo_y - alto_caja))
			var fruta = escenas_frutas[0].instantiate()
			fruta.global_position = Vector2(pos_x, suelo_y - (alto_caja * 2))
			fruta.z_index = 9
			contenedor.add_child(fruta)
	
	return ancho_ocupado # Avisamos cuánto espacio usamos

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
		repro.volume_db = -15.0 
		
		var nueva_cancion = load(ruta_nueva)
		if repro.stream != nueva_cancion:
			repro.stream = nueva_cancion
			repro.play()
