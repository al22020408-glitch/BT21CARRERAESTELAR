extends StaticBody2D

@export var castigo_puntos : int = -50
var ya_choco = false # Seguro para no restar puntos infinitos

func _on_detector_body_entered(body: Node2D) -> void:
	# Verificamos que sea el jugador y que no hayamos chocado ya con ESTA caja
	if body.is_in_group("jugador") and not ya_choco:
		ya_choco = true
		PuntosGlobales.sumar_puntos(castigo_puntos)
		crear_etiqueta_castigo()
		
		# Opcional: si quieres que la caja desaparezca al chocar de frente:
		# queue_free()

func crear_etiqueta_castigo():
	var lb = Label.new()
	lb.text = str(castigo_puntos)
	lb.global_position = global_position
	lb.z_index = 25
	lb.add_theme_color_override("font_color", Color.RED)
	get_tree().root.add_child(lb)
	
	var tw = create_tween()
	tw.tween_property(lb, "position:y", lb.position.y - 60, 0.5)
	tw.parallel().tween_property(lb, "modulate:a", 0.0, 0.5)
	tw.tween_callback(lb.queue_free)
