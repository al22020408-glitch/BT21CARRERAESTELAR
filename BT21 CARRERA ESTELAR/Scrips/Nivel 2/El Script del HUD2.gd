# Script para el nodo CanvasLayer (o HUD) en Nivel 1
extends CanvasLayer

# --- REFERENCIAS EXISTENTES ---
@onready var contenedor_iconos = $ContenedorIconos 

# --- NUEVAS REFERENCIAS PARA BOTONES ---
# Asegúrate de que los nombres coincidan exactamente en tu árbol de nodos
@onready var boton_pausa = $BotonPausa
@onready var boton_play = $BotonPlay

func _ready():
	# 1. Configuración inicial de visibilidad
	boton_pausa.show()
	boton_play.hide()
	
	# 2. Aseguramos que el juego no inicie pausado
	get_tree().paused = false
	

# --- LÓGICA DE PAUSA Y REANUDACIÓN ---

func _on_pausa_pressed() -> void:
	# Pausamos el árbol de escenas
	get_tree().paused = true
	
	# Intercambiamos botones
	boton_pausa.hide()
	boton_play.show()
	print("Partida pausada")


func _on_play_pressed() -> void:
	# Reanudamos el movimiento de Koya y las frutas
	get_tree().paused = false
	
	# Intercambiamos botones de nuevo
	boton_play.hide()
	boton_pausa.show()
	print("Partida reanudada")


# --- TU FUNCIÓN DE BRILLO ORIGINAL ---

func hacer_brillar_icono(nombre: String):
	var icono = contenedor_iconos.get_node_or_null(nombre)
	
	if icono and icono is TextureRect:
		var tw = create_tween()
		
		# Ajuste de pivot para que no se desplace al crecer
		icono.pivot_offset = icono.size / 2
		
		tw.tween_property(icono, "scale", Vector2(1.3, 1.3), 0.1)
		tw.parallel().tween_property(icono, "modulate", Color(2.0, 2.0, 2.0), 0.1)
		
		tw.tween_property(icono, "scale", Vector2(1.0, 1.0), 0.2)
		tw.parallel().tween_property(icono, "modulate", Color(1, 1, 1), 0.2)
