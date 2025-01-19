extends Character

export (int) var speed = 64*3 # Tiles per second

var velocity = Vector2()
var input_buffer = [Vector2.ZERO]
var input_buffer_readout = Vector2()

func _physics_process(_delta): # the code appends the input to a buffer, which only allows one direction of movement at a time.
	if Input.is_action_just_pressed("right"):
		input_buffer.append(Vector2.RIGHT)
	elif Input.is_action_just_pressed("left"):
		input_buffer.append(Vector2.LEFT)
	elif Input.is_action_just_pressed("up"):
		input_buffer.append(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		input_buffer.append(Vector2.DOWN)

	if Input.is_action_just_released("right"):
		input_buffer.erase(Vector2.RIGHT)
	elif Input.is_action_just_released("left"):
		input_buffer.erase(Vector2.LEFT)
	elif Input.is_action_just_released("up"):
		input_buffer.erase(Vector2.UP)
	elif Input.is_action_just_released("down"):
		input_buffer.erase(Vector2.DOWN)

	input_buffer_readout = input_buffer[-1]

#	print(input_buffer)
#	print(input_buffer_readout)

	velocity = input_buffer_readout * speed
	velocity = move_and_slide(velocity)
