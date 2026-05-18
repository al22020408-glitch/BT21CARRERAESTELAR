extends Node

signal puntos_cambiados(nuevo_valor)
signal tiempo_agotado

var META_NIVEL_1 = 1000  # Definimos la meta aquí para que sea única
var puntos : int = 0
var puntos_ultima_partida : int = 0 
var vidas : int = 3                
var tiempo_restante : float = 90.0
var nivel_terminado : bool = false

var VELOCIDAD_ESTANDAR = 300.0

func _process(delta):
	if tiempo_restante > 0 and not nivel_terminado:
		tiempo_restante -= delta
	elif tiempo_restante <= 0 and not nivel_terminado:
		tiempo_restante = 0
		nivel_terminado = true
		tiempo_agotado.emit()

func sumar_puntos(cantidad):
	puntos += cantidad
	puntos_cambiados.emit(puntos)

func resetear_para_reintentar():
	puntos = 0
	tiempo_restante = 90.0
	nivel_terminado = false
	# No tocamos las vidas aquí

func resetear_juego_completo():
	puntos = 0
	puntos_ultima_partida = 0
	vidas = 3
	tiempo_restante = 90.0
	nivel_terminado = false

func activar_super_velocidad(personaje):
	personaje.velocidad = VELOCIDAD_ESTANDAR + 400.0 
	personaje.modulate = Color(1.5, 1.5, 0.5) 
	
	await get_tree().create_timer(5.0).timeout
	
	if is_instance_valid(personaje):
		personaje.velocidad = VELOCIDAD_ESTANDAR
		personaje.modulate = Color(1, 1, 1)
