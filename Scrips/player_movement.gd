extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Conseguimos la gravedad de los ajustes del proyecto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $"."

func _physics_process(delta):
	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Manejar Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")

	# 3. Movimiento Horizontal (Flechas o WASD)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.play("run")
		sprite.flip_h = direction < 0 # Voltear si va a la izquierda
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite.play("run") # O "idle" si tienes esa animación

	move_and_slide()
