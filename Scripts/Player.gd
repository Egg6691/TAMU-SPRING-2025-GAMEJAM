extends Character


#EXPORT VARIABLES 
export var speed = 64 * 5 # tiles per second
export var bullet_speed = 300 # MOVE TO GUN NODE
export var damage = 300
#MOVEMENT VARIABLES
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

#STATES
var facing = Vector2.RIGHT;
var dashing = false;

#FAST BULLET



#STORED NODES
onready var dash_timer = get_node("DashDuration");
onready var animations = get_node("Sprite/AnimationPlayer")
func get_input():
	_movement();
	if(velocity == Vector2.ZERO):
		if not animations.is_playing() or animations.current_animation != "idle":
			animations.play("idle");
	else:
		pass
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
	var bullet = {
		"direction": get_direction_to_mouse(),
		"speed": 64 * 5,
		"damage": damage,
		"team": "player",
		"type": "straight",
		"target": Player.position
	}
	BulletManager._create_bullet(position, bullet);
	
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
	
