extends Node

var reproductor: AudioStreamPlayer

func _ready() -> void:
	reproductor = AudioStreamPlayer.new()
	add_child(reproductor)
	reproductor.volume_db = -10.0 # Volumen seguro

func reproducir_cancion(nueva_cancion: AudioStream):
	if reproductor and nueva_cancion:
		reproductor.stream = nueva_cancion
		reproductor.play()

func alternar_silencio() -> bool:
	reproductor.stream_paused = !reproductor.stream_paused
	return reproductor.stream_paused
