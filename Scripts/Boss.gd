class_name Boss extends KinematicBody2D

enum BossState {
	IDLE,
	MOVING,
	ATTACKING,
	TAKING_DAMAGE,
	DEAD
}

var facing = Vector2.DOWN
var state = BossState.IDLE
var health = 100
var attack_cooldown = 3.0
var is_attacking = false
var is_taking_damage = false
var velocity = Vector2.ZERO
var speed = 100;
var time_in_state = 0;
var animations: AnimationPlayer
var idle_time = 8.0
signal state_changed(new_state)

func _ready():
	pass
	#set_state(BossState.ATTACKING)

func _process(delta):
	match state:
		BossState.IDLE:
			handle_idle(delta)
		BossState.MOVING:
			handle_moving(delta)
		BossState.TAKING_DAMAGE:
			handle_taking_damage(delta)
		BossState.DEAD:
			handle_dead(delta)
	handle_animations()
	time_in_state += delta;

func handle_idle(delta):
	if time_in_state > idle_time:
		decide()

func decide():
	var choices = []
	if state != BossState.ATTACKING:
		choices.append(BossState.ATTACKING);
	#if state != BossState.MOVING:
	#	choices.append(BossState.MOVING);
	var num = rand_range(0,choices.size())
	set_state(choices[num]);
	print(num)
	
func handle_moving(delta):
	print(delta)
	velocity = move_and_slide(position.direction_to(Player.position)*speed);
	if abs(velocity.x) >= abs(velocity.y):
		facing = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
	else:
		facing = Vector2.DOWN if velocity.y > 0 else Vector2.UP
	handle_animations()
	if time_in_state > 3.0:
		set_state(BossState.ATTACKING);
		
func handle_animations():
	pass
	"""
	if velocity.length() > 0:
		match facing:
			Vector2.RIGHT:
				animations.play("walk_right")
			Vector2.LEFT:
				animations.play("walk_left")
			Vector2.UP:
				animations.play("walk_up")
			Vector2.DOWN:
				animations.play("walk_down")
	else:
"""
	match facing:
		Vector2.RIGHT:
			animations.play("idle_right")
		Vector2.LEFT:
			animations.play("idle_left")
		Vector2.UP:
			animations.play("idle_up")
		Vector2.DOWN:
			animations.play("idle_down")

func handle_attacking():
	print("test")
	yield(get_tree().create_timer(perform_attack()), "timeout");
	set_state(BossState.IDLE)

func handle_taking_damage(delta):
	pass; # TODO

func handle_dead(delta):
	queue_free() 

func perform_attack():
	pass
	
func set_state(new_state):
	if state != new_state:
		state = new_state
		emit_signal("state_changed", state)
		time_in_state = 0;
		if(new_state == BossState.ATTACKING):
			handle_attacking()
			
		
func take_damage(amount):
	health -= amount
	if health <= 0 and state != BossState.DEAD:
		set_state(BossState.DEAD)
	else:
		set_state(BossState.TAKING_DAMAGE)

func get_enum_key(value):
	for key in BossState.keys():
		if BossState[key] == value:
			return key
	return null
