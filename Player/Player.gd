extends Character


#EXPORT VARIABLES 
onready var bullet = {
	"direction": get_direction_to_mouse(),
	"speed": 64 * 5,
	"damage": 10,
	"team": "player",
	"type": "beam",
	"target": Player.position,
	"sprite": "res://Images/bullet_orange_small.png"
}
export var speed = 64*6
#MOVEMENT VARIABLES
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var e_velocity = Vector2.ZERO
#STATES
var facing = Vector2.RIGHT;
var dashing = false;
#STORED NODES
onready var dash_timer = get_node("DashDuration");
onready var animations = get_node("Sprite/AnimationPlayer")
onready var animations2 = get_node("Sprite/AnimationPlayer2")
onready var gun = get_node("Gun/Tip")

func get_input():
	_movement();
	if Input.is_action_just_pressed("shoot"):
		_shoot();

func _movement():
	if dashing:
		velocity = facing * speed * 2.5;
	elif Input.is_action_just_pressed('dash'):
		dashing = true;
		dash_timer.start();
		animations2.play("dash")
	else:
		_get_direction()
		velocity = direction.normalized() * speed;
		
func _shoot():
	bullet["direction"] = get_direction_to_mouse();
	BulletManager._create_bullet(gun.global_position, bullet);
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity + e_velocity)
	e_velocity = Vector2.ZERO
	
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
	_update_animation(temp);
	
func _update_animation(movement: Vector2):
	if velocity != Vector2.ZERO:
		if abs(facing.x) >= abs(facing.y):
			animations.play("walk_right" if facing.x > 0 else "walk_left")
	else:
		if abs(facing.x) > abs(facing.y):
			animations.play("idle_right" if facing.x > 0 else "idle_left")
		else:
			animations.play("idle_down" if facing.y > 0 else "idle_up")
func get_direction_to_mouse():
	return (get_global_mouse_position() - global_position).normalized();
	
func _on_DashDuration_timeout():
	dashing = false;
	dash_timer.stop();
	
