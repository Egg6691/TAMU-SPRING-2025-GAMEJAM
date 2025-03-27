extends Sprite

onready var tip = get_node("Tip")
var angular_velocity = 0.0
var damping = 9.0         # Higher values will damp faster.
var spring_strength = 80.0  # Adjust how strongly the gun rotates toward the mouse.

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var target_angle = direction.angle()

	if abs(target_angle) < PI/2:
		scale.y = -abs(scale.y)
	else:
		scale.y = abs(scale.y)
		
	var angle_diff = shortest_angle_diff(rotation, target_angle)
	angular_velocity += angle_diff * spring_strength * delta
	rotation += angular_velocity * delta
	angular_velocity = lerp(angular_velocity, 0, damping * delta)

func recoil(deg):
	angular_velocity += deg2rad(deg)*sign(scale.y)

func shortest_angle_diff(from_angle, to_angle):
	var diff = fmod(to_angle - from_angle + PI, TAU)
	if diff < 0:
		diff += TAU
	return diff - PI

