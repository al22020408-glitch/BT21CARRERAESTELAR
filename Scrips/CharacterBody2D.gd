extends CharacterBody2D

# --- CONFIGURACIÓN DE MOVIMIENTO ---
@export var velocidad = 300.0
@export var fuerza_salto = -450.0

# --- REFERENCIAS A LOS SPRITEFRAMES (Se asignan en el Inspector) ---
@export var frames_koya : SpriteFrames
@export var frames_rj : SpriteFrames
@export var frames_soky : SpriteFrames

@onready var animacion = $AnimatedSprite2D
@onready var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# 1. Configurar el personaje visualmente al aparecer
	configurar_personaje()

func configurar_personaje():
	# Usamos el Global para saber quién debe aparecer
	match Global.personaje_seleccionado:
		"koya":
			animacion.sprite_frames = frames_koya
		"RJ":
			animacion.sprite_frames = frames_rj
		"soky":
			animacion.sprite_frames = frames_soky
		_:
			print("Advertencia: No hay personaje seleccionado en Global, usando Koya por defecto")
			animacion.sprite_frames = frames_koya
	
	animacion.play("idel")

func _physics_process(delta):
	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta

	# 2. Manejar Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = fuerza_salto

	# 3. Movimiento Horizontal
	var direccion = Input.get_axis("ui_left", "ui_right")
	
	if direccion != 0:
		velocity.x = direccion * velocidad
		# Girar el sprite: si direccion es negativa (-1), flip_h es true
		animacion.flip_h = (direccion < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)

	# 4. Ejecutar el movimiento
	move_and_slide()
	
	# 5. Actualizar la animación según lo que está pasando
	actualizar_animaciones(direccion)

func actualizar_animaciones(direccion):
	if not is_on_floor():
		animacion.play("jump")
	elif direccion != 0:
		animacion.play("run")
	elif Input.is_action_pressed("ui_down"): # Si mantienes flecha abajo
		animacion.play("slide")
	else:
		animacion.play("idel")
