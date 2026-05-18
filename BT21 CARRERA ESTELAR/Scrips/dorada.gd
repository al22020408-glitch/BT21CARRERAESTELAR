extends Area2D

# La manzana dorada da más puntos que las normales
@export var valor_puntos : int = 50

func _ready():
	# Conectamos la señal de colisión
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Verificamos que sea el jugador usando el grupo que creamos
	if body.is_in_group("jugador"):
		# 1. Sumamos los puntos al Global
		PuntosGlobales.sumar_puntos(valor_puntos)
		
		# 2. ACTIVAMOS LA VELOCIDAD (Solo en esta fruta)
		# Pasamos 'body' para que el Global sepa a qué personaje darle velocidad
		PuntosGlobales.activar_super_velocidad(body)
		
		# 3. Efecto visual y eliminar la fruta
		crear_etiqueta_puntos()
		queue_free()

func crear_etiqueta_puntos():
	# Creamos un texto flotante para el feedback visual
	var label = Label.new()
	label.text = "+" + str(valor_puntos)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# La posicionamos donde estaba la fruta
	label.global_position = global_position + Vector2(-20, -50)
	get_tree().root.add_child(label)
	
	# Animación: Sube y se desvanece
	var tween = create_tween()
	tween.tween_property(label, "position:y", label.position.y - 100, 0.8)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.8)
	
	# Al terminar la animación, borramos el Label de la memoria
	tween.tween_callback(label.queue_free)
