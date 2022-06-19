extends KinematicBody2D

onready var sprite 	 = get_node("AnimatedSprite")
onready var collider = get_node("CollisionShape")

export (int) var speed = 200

var velocity: Vector2 = Vector2.ZERO
var contador: int = 0

# Esta función se repite
func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	contador += 1
	
# Función para detectar entradas de teclado.	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		sprite.play("run")
		sprite.flip_h = false

	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		sprite.play("run")
		sprite.flip_h = true

	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity == Vector2(0,0):
		sprite.play("idle")	
	velocity = velocity.normalized() * speed
