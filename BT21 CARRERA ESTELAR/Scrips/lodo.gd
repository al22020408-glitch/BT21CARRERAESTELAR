extends Area2D

@export var castigo_lodo : int = -50 

func _ready():
	# Conectamos la señal si no está conectada
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		# 1. Bajamos la variable 'velocidad' del personaje
		body.velocidad = 100.0 # Mucho más lento que 300
		
		# 2. Restamos puntos
		PuntosGlobales.sumar_puntos(castigo_lodo)
		crear_etiqueta_lodo()
		
		# 3. Efecto visual: Koya se pone un poco café o transparente
		body.modulate = Color(0.5, 0.3, 0.1) 
		
		# 4. Desactivamos el lodo para que no castigue mil veces
		set_deferred("monitoring", false) 
		
		# 5. Esperamos 2 segundos y regresamos a la normalidad
		await get_tree().create_timer(2.0).timeout
		
		# Usamos la constante de PuntosGlobales para que vuelva a 300 exactamente
		body.velocidad = PuntosGlobales.VELOCIDAD_ESTANDAR
		body.modulate = Color(1, 1, 1) # Color normal

func crear_etiqueta_lodo():
	var lb = Label.new()
	lb.text = str(castigo_lodo)
	lb.global_position = global_position + Vector2(0, -50)
	lb.z_index = 25
	lb.add_theme_color_override("font_color", Color(0.5, 0.2, 0.0)) # Café lodo
	get_tree().root.add_child(lb)
	
	var tw = create_tween()
	tw.tween_property(lb, "position:y", lb.position.y - 60, 0.8)
	tw.parallel().tween_property(lb, "modulate:a", 0.0, 0.8)
	tw.tween_callback(lb.queue_free)
