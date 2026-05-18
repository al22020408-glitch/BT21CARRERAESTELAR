extends Control

# Referencias a tus nodos según el árbol
@onready var label_score = $HUD/Label_score
@onready var label_lives_text = $vidas
@onready var control_vidas = $PanelResultado/VidasContainer/Controlvidas
@onready var control_estrellas = $PanelResultado/EstrellasContainer2/Controlestrellas
@onready var label_grande = $Label_Grande

# Variables para el carrusel
var velocidad_giro = 150.0 # Ajusta qué tan rápido "gira" el texto
var limite_derecho = 600.0  # Punto donde el texto vuelve a empezar

func _ready():
	# 1. Configuración de datos
	label_score.text = "SCORE: " + str(PuntosGlobales.puntos_ultima_partida)
	label_lives_text.text = "LIVES: " + str(PuntosGlobales.vidas)
	
	actualizar_corazones()
	actualizar_estrellas(PuntosGlobales.puntos_ultima_partida)
	
	# 2. Posición inicial del carrusel
	label_grande.position.x = -limite_derecho

func _process(delta):
	# 1. CAMBIO: Restamos en lugar de sumar para que vaya a la IZQUIERDA
	label_grande.position.x -= velocidad_giro * delta
	
	# 2. Lógica de reinicio: 
	# Si el texto desaparece por la izquierda (es menor que -limite_derecho)
	# lo teletransportamos al borde derecho (+limite_derecho)
	if label_grande.position.x < -limite_derecho:
		label_grande.position.x = limite_derecho

# --- LÓGICA VISUAL ---
func actualizar_corazones():
	var corazones = control_vidas.get_children()
	for i in range(corazones.size()):
		if i >= PuntosGlobales.vidas:
			corazones[i].visible = false

func actualizar_estrellas(pts):
	var estrellas = control_estrellas.get_children()
	for e in estrellas: e.modulate.a = 0.2 # Apagadas por defecto
	
	# Encendido progresivo (ajusta según tu meta de 1000)
	if pts >= 200: estrellas[0].modulate.a = 1.0
	if pts >= 400: estrellas[1].modulate.a = 1.0
	if pts >= 600: estrellas[2].modulate.a = 1.0
	if pts >= 800: estrellas[3].modulate.a = 1.0
	if pts >= 1000: estrellas[4].modulate.a = 1.0

# --- BOTONES ---

func _on_botonjugar_pressed():
	# Limpia puntos pero mantiene vidas para el siguiente nivel
	PuntosGlobales.resetear_para_reintentar()
	# Te lleva a la escena de selección de niveles
	get_tree().change_scene_to_file("res://BT21 CARRERA ESTELAR/Scenes/mundos.tscn")

	

func _on_boton_salir_pressed() -> void:
	# Cierra el juego
	get_tree().quit()


func _on_boton_silenciar_pressed() -> void:
	# Togle (Mute/Unmute) del audio general
	var bus_idx = AudioServer.get_bus_index("Master")
	var estado_actual = AudioServer.is_bus_mute(bus_idx)
	AudioServer.set_bus_mute(bus_idx, not estado_actual)
