extends KinematicBody2D
# Movimiento lineal

# Variables:
export (int) var speed = 200					#Velocidad con la que se mueve
export (int) var jump_speed = -200				#Fuerza de salto
export (int) var gravity = 500					#Fuerza de gravedad

export (float, 0, 1.0) var friction = 0.1		#Fricción
export (float, 0, 1.0) var acceleration = 0.5	#Aceleración

export (Curve) var acceleration_curve

var velocity = Vector2.ZERO

# 
func _ready() -> void:
	if acceleration_curve == null:
		print_debug("ERROR: no se establecio curva de movimiento.")
	else:
		acceleration_curve.max_value = speed

# Funcion para detectar entradas de teclado
func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		#velocity.x = lerp(velocity.x, dir * speed, acceleration)
		velocity.x = dir*curve_interpolation(acceleration_curve, speed, velocity.x)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

# Loop principal del personaje
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed

func normalize(value: float) -> float:
	return value / 1000

func curve_interpolation(curve: Curve, value: float, top_value: float) -> float:
	if value == 0:
		value = 100.0
	var temp: float = top_value * curve.interpolate(value/1000.0)
	print(temp)
	return temp
