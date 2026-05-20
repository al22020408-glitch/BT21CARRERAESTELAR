extends Node2D

@export var frames_koya : SpriteFrames
@export var frames_rj : SpriteFrames
@export var frames_soky : SpriteFrames

@onready var jugador = $CharacterBody2D # Asegúrate de que el nombre sea correcto

func _ready():
	
	# Aquí podrías cambiar la música si quieres una específica para el nivel
	if has_node("/root/Musica"):
		var repro = Musica.get_node("ReproductorMusica")
		# repro.stream = load("res://Audio/MusicaNivel.mp3")
		# repro.play()
		pass
	
	# El Nivel solo configura el look inicial, no controla el salto ni gravedad
	var anim = jugador.get_node("AnimatedSprite2D")
	match Global.personaje_seleccionado:
		"koya": anim.sprite_frames = frames_koya
		"RJ": anim.sprite_frames = frames_rj
		"soky": anim.sprite_frames = frames_soky
	anim.play("idel")
