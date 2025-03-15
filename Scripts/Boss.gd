class_name Boss extends KinematicBody2D

enum BossState {
	IDLE,
	MOVING,
	ATTACKING,
	TAKING_DAMAGE,
	DEAD
}


var state = BossState.IDLE
var health = 100
var attack_cooldown = 3.0
var is_attacking = false
var is_taking_damage = false
var speed = 50;
var time_in_state = 0;
var animations: AnimationPlayer
signal state_changed(new_state)

func _ready():
	set_state(BossState.IDLE)

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
	time_in_state += delta;

func handle_idle(delta):
	if time_in_state > 8.0:
		decide()

func decide():
	var choices = []
	if state != BossState.ATTACKING:
		choices.append(BossState.ATTACKING);
	if state != BossState.MOVING:
		choices.append(BossState.MOVING);
	var num = rand_range(0,choices.size())
	print(get_enum_key(num))
	set_state(choices[num]);
	
func handle_moving(delta):
	position += position.direction_to(Player.position)*speed;
	if time_in_state > 3.0:
		set_state(BossState.ATTACKING);

func handle_attacking():
	yield(get_tree().create_timer(perform_attack()), "timeout");
	set_state(BossState.IDLE)

func handle_taking_damage(delta):
	pass;

func handle_dead(delta):
	queue_free() 

func perform_attack():
	2.0;
	
func set_state(new_state):
	if state != new_state:
		state = new_state
		emit_signal("state_changed", state)
		time_in_state = 0;
		if animations != null and animations.has_animation(get_enum_key(new_state)):
			animations.play(get_enum_key(new_state))
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
