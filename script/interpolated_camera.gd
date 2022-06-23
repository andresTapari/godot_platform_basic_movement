extends Camera2D

# Variables de 
export var camera_top_speed = 10					# Camara velocidad tope
export (NodePath) var camera_target = null			# Target a seguir
export (float, 0.01 , 1) var x_reaction = .7		# Reaccion en x
export (float, 0.01 , 1) var y_reaction = .7		# Reaccion en x
export (int, -100 , 100) var x_offset = 0			# Offset en x
export (int, -100 , 100) var y_offset = -50			# Offset en y

var target = null									# Objetivo a seguir
var x_camera_speed = 10
var y_camera_speed = 10

func _ready() -> void:
	if camera_target:
		target = get_node(camera_target)
		x_camera_speed = lerp(0.1,camera_top_speed,x_reaction)	# Velocidad en x 
		y_camera_speed = lerp(0.1,camera_top_speed,y_reaction)	# Velocidad en y
		self.position = Vector2(target.position.x + x_offset,target.position.y + y_offset)	# Alineamos la camara 
	else:
		print_debug("ERROR: No se selecciono target para la camara.")

func _process(delta) -> void:
	if target:
		position.x = lerp(self.position.x,target.position.x + x_offset,x_camera_speed*delta)
		position.y = lerp(self.position.y,target.position.y + y_offset,y_camera_speed*delta)


