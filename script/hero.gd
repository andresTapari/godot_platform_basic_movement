extends KinematicBody2D
# Propiedades:
export (int) var speed = 200					#Velocidad con la que se mueve
export (int) var jump_speed = -200				#Fuerza de salto
export (int) var gravity = 500					#Fuerza de gravedad
export (float, 0, 1.0) var friction = 0.1		#Fricción
export (float, 0, 1.0) var acceleration = 0.5	#Aceleración

# Nodos hijos:
onready var animation_tree_node = get_node("AnimationTree")
onready var sprite = get_node("Sprite")


# Variables internas
onready var state_machine = animation_tree_node.get("parameters/playback")
var velocity = Vector2.ZERO

# Inicio del personaje:
func _ready() -> void:
	state_machine.start("idle")


# Funcion para detectar entradas de teclado
func get_input() -> void:
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		dir += 1
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		dir -= 1
	if dir != 0:
		#state_machine.travel("run")
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		#state_machine.travel("idle")
		velocity.x = lerp(velocity.x, 0, friction)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			state_machine.travel("jump")
			velocity.y = jump_speed
		else:
			state_machine.travel("falling")
	
	# Actualizamos las animaciones
	if int(velocity.length()) ==  0 or is_on_floor():	#si esta quieto o esta sobre el suelo
		state_machine.travel("idle")
	
	if abs(velocity.x) > 50:							# si su movimiento en x es mayor a 50
		state_machine.travel("run")
	
	if velocity.y < 0:
		state_machine.travel("jump")					# si se mueve hacia arriba

	elif velocity.y > 0: 
		state_machine.travel("falling")					# si se mueve hacia abajo
	
func _physics_process(delta) -> void:
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)