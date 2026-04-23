extends Control

# Ruta de la escena del menú
# Cambia esta línea:
@export var escena_menu = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"

# Referencia al nodo del logo (TextureRect2)
@onready var logo = $TextureRect2 

var posicion_final_y: float 

func _ready():
	# 1. Guardamos la posición donde pusiste el logo en el editor (la meta)
	posicion_final_y = logo.position.y
	
	# 2. Movemos el logo ARRIBA, fuera de la pantalla.
	# Usamos el tamaño del logo en negativo para que se oculte por completo.
	logo.position.y = -logo.size.y - 100 
	
	# 3. Iniciamos la caída
	iniciar_animacion_caida()
	
	# 4. Conectamos el Timer para cambiar de escena
	$Timer.timeout.connect(_on_timer_timeout)

func iniciar_animacion_caida():
	var tween = create_tween()
	
	# Transición hacia la posición final en 1.2 segundos
	tween.tween_property(logo, "position:y", posicion_final_y, 1.2)
	
	# Configuración de suavizado
	tween.set_ease(Tween.EASE_OUT)
	
	# TRANS_BACK le dará un rebote muy tierno al llegar, ideal para BT21
	tween.set_trans(Tween.TRANS_BACK) 

func _on_timer_timeout():
	get_tree().change_scene_to_file(escena_menu)
