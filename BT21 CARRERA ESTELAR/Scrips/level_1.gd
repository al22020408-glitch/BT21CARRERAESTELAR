extends Control
# Ruta de tu menú principal
@export var escena_menu = "res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn"

@onready var boton_atras = $Fondo/BotonAtras

func _ready():
	# Conectamos el botón de retroceso
	if boton_atras:
		boton_atras.pressed.connect(_on_atras_pressed)

func _on_atras_pressed():
	print("Lead: Regresando al Menú Principal...")
	
	# Si solo quieres volver al menú:
	get_tree().change_scene_to_file(escena_menu)
	
	# OPCIONAL: Si prefieres que funcione como PAUSA (congelar el juego)
	# get_tree().paused = true
	# $HUD/PanelPausa.show()
