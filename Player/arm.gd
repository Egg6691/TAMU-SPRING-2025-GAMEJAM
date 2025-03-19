extends Sprite

onready var tip = get_node("Tip")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var angle_to_mouse = direction.angle()
	if abs(angle_to_mouse) < PI/2: 
		scale.y = -abs(scale.y)
	else:
		scale.y = abs(scale.y)
	rotation = angle_to_mouse
