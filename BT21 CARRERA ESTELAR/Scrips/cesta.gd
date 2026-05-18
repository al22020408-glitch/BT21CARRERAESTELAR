extends Area2D

@export var valor_puntos : int = 100 

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		PuntosGlobales.sumar_puntos(valor_puntos)
		crear_etiqueta_puntos(Color.GREEN)
		queue_free()

func crear_etiqueta_puntos(color_texto):
	var lb = Label.new()
	lb.text = "+" + str(valor_puntos)
	
	# --- CAMBIO CLAVE ---
	# En lugar de get_tree().root, usamos get_parent()
	# Así, la etiqueta es hija del nivel y se borra al cambiar de escena
	get_parent().add_child(lb)
	
	# Ponemos la posición DESPUÉS de añadirlo al padre
	lb.global_position = global_position
	lb.z_index = 25
	lb.add_theme_color_override("font_color", color_texto)
	
	var tw = create_tween()
	# Usamos lb.position.y para que el movimiento sea relativo a su nueva posición
	tw.tween_property(lb, "position:y", lb.position.y - 100, 0.7)
	tw.parallel().tween_property(lb, "modulate:a", 0.0, 0.7)
	tw.tween_callback(lb.queue_free)
