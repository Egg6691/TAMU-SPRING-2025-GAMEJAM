extends Sprite


onready var gun = get_node("Gun")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var angle_to_mouse = direction.angle()
	if abs(angle_to_mouse) < PI/2: 
		gun.flip_v = true;
	else:
		gun.flip_v = false;
	rotation = angle_to_mouse
