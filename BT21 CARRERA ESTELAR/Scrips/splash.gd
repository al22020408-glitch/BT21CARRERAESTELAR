extends Control

# Ruta de la escena del menú
@export var escena_menu = "res://BT21 CARRERA ESTELAR/Scenes/SeleccionPersonaje.tscn"

# Referencia al nodo del logo (TextureRect2)
@onready var logo = $vistainicio/icono

func _ready():
	# 1. Ya no movemos el logo hacia arriba.
	# 2. Ya no llamamos a la función de caída.
	
	# 3. Solo mantenemos el Timer para cambiar de escena
	$Timer.timeout.connect(_on_timer_timeout)

# Borramos o comentamos la función de animación para que no haga nada
func iniciar_animacion_caida():
	pass 

func _on_timer_timeout():
	get_tree().change_scene_to_file(escena_menu)
