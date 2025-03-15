extends Sprite



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var angle_to_mouse = direction.angle()-(PI/2)+(PI/6)
	rotation = angle_to_mouse
