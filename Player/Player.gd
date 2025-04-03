extends Character


#EXPORT VARIABLES 
onready var bullet = {
	"direction": get_direction_to_mouse(),
	"speed": 64 * 8,
	"damage": 10,
	"team": "player",
	"type": "straight",
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
var canShoot = true;
#STORED NODES
onready var dash_timer = get_node("DashDuration");
onready var animations = get_node("Sprite/AnimationPlayer")
onready var animations2 = get_node("Sprite/AnimationPlayer2") #ONLY USED FOR DASH FLICKERING RIGHT NOW
onready var fire_rate = get_node("FireRate")
onready var gun = get_node("Gun")

func get_input():
	_movement();
	if Input.is_action_just_pressed("shoot") and canShoot:
		_shoot();

func _movement():
	if dashing:
		velocity = facing * speed * 1.75;
	elif Input.is_action_just_pressed('dash') and velocity != Vector2.ZERO:
		dashing = true;
		dash_timer.start();
		animations2.play("dash")
	else:
		_get_direction()
		velocity = direction.normalized() * speed;
		
func _shoot():
	if fire_rate.is_stopped():
		bullet["direction"] = Vector2(cos(gun.rotation),sin(gun.rotation)).normalized()
		BulletManager._create_bullet(gun.get_child(0).global_position, bullet); # TODO: TEMP SOLUTION FOR GUN TIP POSITION
		fire_rate.start()
		gun.recoil(160)
		AudioManager._play_sound("shoot");
		AudioManager._play_sound("reload");
	
	
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
	
