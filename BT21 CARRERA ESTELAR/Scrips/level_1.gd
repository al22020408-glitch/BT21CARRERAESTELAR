extends Control

# --- CONFIGURACIÓN ---
@export var escena_menu = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"
var puntos = 0
var vidas = 3

# --- REFERENCIAS A UI (Rutas corregidas según tus imágenes) ---
@onready var label_score = $Node2D/UI/HUD/ScoreContainer/Label_Score
@onready var label_vidas = $Node2D/UI/HUD/Node2D/Label_Vidas
@onready var mensaje_ganaste = $Node2D/UI/Mensajes/Ganaste
@onready var boton_atras = $Fondo/BotonAtras
@onready var btn_pausa = $Node2D/UI/HUD/Btn_Pausa

# Referencias a Frutas corregidas (FrutasUI2 es el nombre en tu editor)
@onready var manzana_on = $Node2D/UI/FrutasUI2/FrutasUI/Manzana_ON2
@onready var platano_on = $Node2D/UI/FrutasUI2/FrutasUI/Platano_ON3
@onready var fresa_on = $Node2D/UI/FrutasUI2/FrutasUI/Fresa_ON4

func _ready():
	# 1. Inicializar UI
	actualizar_interfaz()
	
	# Verificamos si los nodos existen antes de esconderlos para evitar el error 'null instance'
	if mensaje_ganaste: mensaje_ganaste.hide()
	if manzana_on: manzana_on.hide()
	if platano_on: platano_on.hide()
	if fresa_on: fresa_on.hide()

	# 2. Conectar Botones
	if boton_atras:
		boton_atras.pressed.connect(_on_atras_pressed)
	if btn_pausa:
		btn_pausa.pressed.connect(_on_pausa_pressed)
	
	# 3. Conectar Coleccionables (Señales de tus Area2D)
	conectar_señales_grupo("Fresas", _on_fruta_recogida)
	conectar_señales_grupo("Obstaculos", _on_obstaculo_tocado)
	conectar_señales_grupo("premio", _on_premio_recogido)

func conectar_señales_grupo(nombre_grupo, funcion):
	var contenedor = get_node_or_null(nombre_grupo)
	if contenedor:
		for objeto in contenedor.get_children():
			if objeto.has_signal("body_entered"):
				objeto.body_entered.connect(funcion.bind(objeto))

# --- LÓGICA DE JUEGO ---

func actualizar_interfaz():
	if label_score: label_score.text = str(puntos)
	if label_vidas: label_vidas.text = "LIVES: " + str(vidas)

func _on_fruta_recogida(body, objeto):
	if body.name == "Jugador": # Verifica que sea tu CharacterBody2D
		puntos += 100
		var tipo = objeto.name.to_lower()
		
		if "manzana" in tipo: manzana_on.show()
		if "platano" in tipo: platano_on.show()
		if "fresa" in tipo: fresa_on.show()
		
		actualizar_interfaz()
		objeto.queue_free() # Elimina la fruta del mapa

func _on_obstaculo_tocado(body, _objeto):
	if body.name == "Jugador":
		vidas -= 1
		actualizar_interfaz()
		if vidas <= 0:
			get_tree().reload_current_scene()

func _on_premio_recogido(body, _objeto):
	if body.name == "Jugador":
		mensaje_ganaste.show()
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(escena_menu)

func _on_atras_pressed():
	get_tree().change_scene_to_file(escena_menu)

func _on_pausa_pressed():
	get_tree().paused = !get_tree().paused
