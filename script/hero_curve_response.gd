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
		print_debug("ERROR: no se establecio curva de movimiento")
		pass
	

# Funcion para detectar entradas de teclado
func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
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
