extends Control

# --- REFERENCIAS CORREGIDAS ---
# Usamos las rutas que te dio Godot (incluyendo /Panel/)
@onready var popup = $PopupSeleccion
@onready var sprite_grande = $PopupSeleccion/Panel/Contenido/Sprite_Grande
@onready var label_nombre_grande = $PopupSeleccion/Panel/Contenido/nombre
# --- TEXTURAS ---
@export var textura_koya : Texture2D
@export var textura_rj : Texture2D
@export var textura_soky : Texture2D

var seleccion_temporal : String = ""


func _ready() -> void:
	Musica.play()# Esto hará que empiece justo al entrar a esta pantalla
	popup.hide() 

# --- FUNCIONES DE PERSONAJES ---

func _on_koya_pressed() -> void:
	seleccion_temporal = "koya"
	print("Marcado: Koya")

func _on_rj_pressed() -> void:
	seleccion_temporal = "RJ"
	print("Marcado: RJ")

func _on_soky_pressed() -> void:
	seleccion_temporal = "soky"
	print("Marcado: soky")

# --- BOTÓN CONFIRMAR ---

func _on_btn_confirmar_pressed() -> void:
	if seleccion_temporal == "":
		print("Debes elegir a alguien primero")
		return
	
	# 1. Guardar en Global
	Global.personaje_seleccionado = seleccion_temporal
	
	# 2. Configurar el Popup visual
	# Verificamos que el nodo exista antes de asignarle texto
	if label_nombre_grande:
		label_nombre_grande.text = seleccion_temporal.to_upper()
	
	# 3. Asignar textura al Sprite_Grande
	if sprite_grande:
		match seleccion_temporal:
			"koya":
				sprite_grande.texture = textura_koya
			"RJ":
				sprite_grande.texture = textura_rj
			"soky":
				sprite_grande.texture = textura_soky
	
	# 4. Mostrar popup y cambiar escena
	popup.show()
	await get_tree().create_timer(2.0).timeout
	
	# Asegúrate de que esta ruta sea correcta según tus carpetas
	get_tree().change_scene_to_file("res://BT21 CARRERA ESTELAR/Scenes/MenuBts.tscn")
	
