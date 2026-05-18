extends ParallaxBackground

# Controla la rapidez del movimiento desde el Inspector
@export var velocidad_scroll : float = 100.0

func _process(delta):
	# Restamos a scroll_offset.x para que la imagen "viaje" hacia la izquierda
	scroll_offset.x -= velocidad_scroll * delta
