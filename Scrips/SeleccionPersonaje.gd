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
		print("No hay personaje seleccionado")
		return
	
	# 1. Guardar elección
	Global.personaje_seleccionado = seleccion_temporal
	
	# 2. Actualizar texto y mostrar popup
	label_nombre_grande.text = seleccion_temporal.to_upper()
	
	# 3. Asignar la imagen (Asegúrate de que las variables tengan imagen en el Inspector)
	match seleccion_temporal:
		"koya":
			sprite_grande.texture = textura_koya
		"RJ":
			sprite_grande.texture = textura_rj
		"soky":
			sprite_grande.texture = textura_soky
	
	popup.show()
	print("Popup mostrado, esperando 2 segundos...")

	# 4. Espera y cambio de escena
	# Usamos una forma más directa para evitar que se quede trabado
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	
	print("Cambiando al menú...")
	# ¡IMPORTANTE! Verifica que esta ruta sea EXACTAMENTE la de tu archivo de menú
	var error = get_tree().change_scene_to_file("res://Scenes/MenuBts.tscn")
	
	if error != OK:
		print("ERROR al cambiar de escena: Revisa la ruta en el código")
