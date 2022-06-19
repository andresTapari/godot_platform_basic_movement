extends KinematicBody2D

onready var sprite = get_node('animacion')


var vel: Vector2 = Vector2.ZERO

func _ready() -> void:
	print("Hola")
	
func _process(_lamba) -> void:
	input()
	pass

func input() -> void:
	pass
