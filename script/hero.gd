extends KinematicBody2D
# Propiedades:
export (int) var speed = 200					#Velocidad con la que se mueve
export (int) var jump_speed = -200				#Fuerza de salto
export (int) var gravity = 500					#Fuerza de gravedad
export (float, 0, 1.0) var friction = 0.1		#Fricción
export (float, 0, 1.0) var acceleration = 0.5	#Aceleración

# Nodos hijos:
onready var animation_tree_node = get_node("AnimationTree")
onready var rayCastWall = get_node('RayCast/RayCast2D_wall')
onready var rayCastEdge = get_node('RayCast/RayCast2D_edge')
onready var rayCast = get_node('RayCast')
onready var sprite = get_node("Sprite")

# Variables internas
onready var state_machine = animation_tree_node.get("parameters/playback")
var is_on_edge: bool = false
var velocity = Vector2.ZERO

enum state {idle,					# estar
			run,					# correr
			jump,					# saltar
			fall,					# caer
			on_edge					# borde
		}
var current_state = state.idle

# Inicio del personaje:
func _ready() -> void:
	state_machine.start("idle")

# Funcion para detectar entradas de teclado
func _physics_process(delta) -> void:
	var dir: int = 0
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
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
		if is_on_edge:
			is_on_edge = false
			velocity.y = jump_speed

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	
	update_animation(velocity)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func update_animation(current_direction: Vector2) -> void:
	# Animacion de correr o estar:
	if is_on_floor():
		if abs(current_direction.x) > 50:
			state_machine.travel('run')
		else:
			state_machine.travel('idle')
	
	# Animacion de saltar:
	if current_direction.y < 0:
		state_machine.travel('jump')
	
	# Animacion de caer o agarrar borde
	elif !is_on_floor():
		if !is_on_edge:
			state_machine.travel('falling')
		else:
			state_machine.travel('edge_grab')

func check_grab_edge(current_velocity) -> Vector2:
	
	return current_velocity