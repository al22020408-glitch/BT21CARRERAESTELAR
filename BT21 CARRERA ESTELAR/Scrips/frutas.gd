extends Area2D

# --- VARIABLES ---
@export var nombre_fruta : String = "" 
@export var valor_puntos : int = 10 

func _ready():
	if nombre_fruta == "":
		push_warning("A la fruta " + name + " le falta el 'nombre_fruta' exportado en el Inspector.")
		
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		# 1. Sumar puntos
		PuntosGlobales.sumar_puntos(valor_puntos)
		
		# 2. REPRODUCIR SONIDO (Nueva lógica)
		reproducir_sonido_recoleccion()
		
		# 3. Lógica de brillo de iconos
		if nombre_fruta != "":
			var canvas_layer = get_tree().current_scene.get_node_or_null("CanvasLayer")
			if canvas_layer and canvas_layer.has_method("hacer_brillar_icono"):
				canvas_layer.hacer_brillar_icono(nombre_fruta)
		
		# 4. Efectos visuales y desaparecer
		crear_etiqueta_puntos()
		queue_free()

# --- NUEVA FUNCIÓN DE AUDIO ---
func reproducir_sonido_recoleccion():
	var player_en_fruta = get_node_or_null("AudioStreamPlayer2D")
	
	if player_en_fruta and player_en_fruta.stream:
		# Creamos el reproductor pero lo configuramos para que sea un efecto de sonido (SFX)
		var sfx = AudioStreamPlayer.new()
		sfx.stream = player_en_fruta.stream
		
		# IMPORTANTE: Asegúrate de que el volumen no sea 0.0 (que es el máximo)
		# Ponlo en un valor negativo para que no tape la música
		sfx.volume_db = -12.0 
		
		# Lo añadimos a la escena actual, NO al root (así no interfiere con el Autoload)
		get_tree().current_scene.add_child(sfx)
		
		sfx.play()
		sfx.finished.connect(sfx.queue_free)

func crear_etiqueta_puntos():
	var lb = Label.new()
	lb.text = "+" + str(valor_puntos)
	lb.global_position = global_position
	lb.z_index = 20 
	
	get_parent().add_child(lb) 
	
	var tw = create_tween()
	tw.tween_property(lb, "position:y", lb.position.y - 80, 0.6)
	tw.parallel().tween_property(lb, "modulate:a", 0.0, 0.6)
	tw.tween_callback(lb.queue_free)
