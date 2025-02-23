extends Character


#EXPORT VARIABLES 
export var speed = 64 * 3 # tiles per second
export var bullet_speed = 300
export var damage = 300
#MOVEMENT VARIABLES
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

#STATES
var facing = Vector2.RIGHT;
var dashing = false;

#STORED NODES
onready var dash_timer = get_node("DashDuration");

func get_input():
	velocity = Vector2.ZERO
	_movement();
	if Input.is_action_just_pressed("shoot"):
		_shoot();

func _movement():
	if dashing:
		velocity = facing * speed * 1.5;
	elif Input.is_action_just_pressed('dash'):
		dashing = true;
		dash_timer.start();
	else:
		_get_direction()
		velocity = direction.normalized() * speed;
		
func _shoot():
	BulletManager.create_bullet(position, get_direction_to_mouse(), bullet_speed, damage, "player");
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
func _get_direction():
	var temp = Vector2.ZERO
	if Input.is_action_pressed('right'):
		temp.x += 1
	if Input.is_action_pressed('left'):
		temp.x -= 1
	if Input.is_action_pressed('down'):
		temp.y += 1
	if Input.is_action_pressed('up'):
		temp.y -= 1
	if(temp != Vector2.ZERO):
		facing = temp.normalized();
	direction = temp.normalized();
func get_direction_to_mouse():
	return (get_global_mouse_position() - global_position).normalized();
func _on_DashDuration_timeout():
	dashing = false;
	dash_timer.stop();
	
