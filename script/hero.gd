extends KinematicBody2D
# Propiedades:
export (int) var speed = 200					#Velocidad con la que se mueve
export (int) var jump_speed = -200				#Fuerza de salto
export (int) var grab_jump = -180
export (int) var gravity = 500					#Fuerza de gravedad
export (float, 0, 1.0) var friction = 0.1		#Fricción
export (float, 0, 1.0) var acceleration = 0.5	#Aceleración

# Nodos hijos:
onready var animation_tree_node = get_node("AnimationTree")
onready var rayCastWall = get_node('RayCast/RayCast2D_wall')
onready var rayCastEdge = get_node('RayCast/RayCast2D_edge')
onready var labelState  = get_node('Label')
onready var rayCast = get_node('RayCast')
onready var sprite = get_node("Sprite")

# Variables internas
onready var state_machine = animation_tree_node.get("parameters/playback")
var is_on_edge: bool = false
var velocity = Vector2.ZERO

# Inicio del personaje:
func _ready() -> void:
	state_machine.start("idle")

# Funcion para detectar entradas de teclado
func _physics_process(delta) -> void:
	var dir: int = 0
	# Teclas presionadas:
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		dir += 1
		rayCast.scale.x = 1
	
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		dir -= 1
		rayCast.scale.x = -1
	
	if Input.is_action_pressed('ui_down'):
		is_on_edge = false
		disable_raycast()

	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
		if is_on_edge:
			is_on_edge = false
			velocity.y = grab_jump
			disable_raycast()

	# Direccion de movimiento
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	# 
	if !is_on_edge:
		velocity.y += gravity * delta
	
	velocity = check_grab_edge(velocity)
	update_animation(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	#velocity = move_and_collide(velocity)


func update_animation(current_direction: Vector2) -> void:
	# Animacion de correr o estar:
	if is_on_floor():
		if abs(current_direction.x) > 50:
			state_machine.travel('run')
			labelState.text = "RUN"
		else:
			state_machine.travel('idle')
			labelState.text = "IDLE"
	# Animacion de saltar:
	if current_direction.y < 0:
		state_machine.travel('jump')
		labelState.text = "JUMP"
	# Animacion de caer o agarrar borde
	elif !is_on_floor():
		if !is_on_edge:
			state_machine.travel('falling')
			labelState.text = "FALLING"
		else:
			state_machine.travel('edge_grab')
			labelState.text = "EDGE"

func check_grab_edge(current_velocity) -> Vector2:
	rayCastEdge.update()
	rayCastWall.update()
	if !rayCastEdge.is_colliding() and rayCastWall.is_colliding() and !is_on_edge:
		is_on_edge = true
		current_velocity.y = 0
	if !rayCastEdge.is_colliding() and !rayCastWall.is_colliding():
		is_on_edge = false
	return current_velocity

func disable_raycast() -> void:
	rayCastEdge.enabled = false
	rayCastWall.enabled = false
	$Timer.start()

func _on_Timer_timeout() -> void:
	rayCastEdge.enabled = true
	rayCastWall.enabled = true
