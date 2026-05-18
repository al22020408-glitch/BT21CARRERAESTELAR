extends Control

@onready var label_score = $HUD/Label_score
@onready var label_lives_text = $vidas
@onready var control_vidas = $PanelResultado/VidasContainer/Controlvidas
@onready var control_estrellas = $PanelResultado/EstrellasContainer2/Controlestrellas

func _ready():
	# 1. Mostrar Score y Vidas en texto
	label_score.text = "SCORE: " + str(PuntosGlobales.puntos_ultima_partida)
	label_lives_text.text = "LIVES: " + str(PuntosGlobales.vidas)
	
	# 2. Actualizar corazones y estrellas
	actualizar_corazones()
	actualizar_estrellas(PuntosGlobales.puntos_ultima_partida)

func actualizar_corazones():
	var corazones = control_vidas.get_children()
	for i in range(corazones.size()):
		# Si i es mayor o igual a las vidas, ocultamos el corazón
		if i >= PuntosGlobales.vidas:
			corazones[i].visible = false

func actualizar_estrellas(pts):
	var estrellas = control_estrellas.get_children()
	
	# 1. Primero, apagamos todas (Asegúrate de que esta línea esté indentada)
	for e in estrellas:
		e.modulate.a = 0.2 

	# 2. Encendemos según puntaje (Usa rangos según tu meta de 1000)
	# IMPORTANTE: El código debajo del 'if' debe tener un nivel más de indentación
	if pts >= 200:
		estrellas[0].modulate.a = 1.0
	if pts >= 400:
		estrellas[1].modulate.a = 1.0
	if pts >= 600:
		estrellas[2].modulate.a = 1.0
	if pts >= 800:
		estrellas[3].modulate.a = 1.0
	if pts >= 1000:
		estrellas[4].modulate.a = 1.0
		
		
# --- SEÑALES DE BOTONES ---

func _on_botonjugar_pressed():
	if PuntosGlobales.vidas > 0:
		PuntosGlobales.resetear_para_reintentar()
		# Verifica que esta ruta sea exacta a tu archivo del nivel
		get_tree().change_scene_to_file("res://BT21 CARRERA ESTELar/Scenes/Level1.tscn")
	else:
		PuntosGlobales.resetear_juego_completo()
		get_tree().change_scene_to_file("res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn")
	


func _on_boton_salir_pressed() -> void:
	# Cierra la aplicación
	get_tree().quit()

func _on_boton_silenciar_pressed() -> void:
	# Silencia o activa el sonido global
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, not AudioServer.is_bus_mute(master_bus))
	print("Sonido cambiado") # Para que veas en consola que funciona
