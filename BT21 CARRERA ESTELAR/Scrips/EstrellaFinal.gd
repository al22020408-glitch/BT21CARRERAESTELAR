extends Area2D

# --- CONFIGURACIÓN ---
@export var siguiente_escena = "res://BT21 CARRERA ESTELAR/Scenes/win_screen.level1.tscn"

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		# 1. Bloqueamos para que no se active dos veces
		set_deferred("monitoring", false) 
		
		# 2. Avisamos que el nivel terminó
		PuntosGlobales.nivel_terminado = true
		
		# 3. Efectos visuales (Opcional)
		# Podemos hacer que la estrella brille o se agrande antes de irnos
		var tw = create_tween()
		tw.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2)
		tw.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
		
		print("¡Estrella tocada! Esperando un momento...")
		
		# 4. PAUSA DRAMÁTICA (0.5 segundos)
		# Esto permite que el jugador vea que tocó la estrella antes de cambiar
		await get_tree().create_timer(0.5).timeout
		
		# 5. CAMBIO DE ESCENA
		get_tree().change_scene_to_file(siguiente_escena)
