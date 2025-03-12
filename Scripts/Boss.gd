class_name Boss extends KinematicBody2D

enum BossState {
	IDLE,
	ATTACKING,
	TAKING_DAMAGE,
	DEAD
}

var state = BossState.IDLE
var health = 100
var attack_timer = 2.0
var attack_cooldown = 0.0
var is_attacking = false
var is_taking_damage = false

signal state_changed(new_state)

func _ready():
	set_state(BossState.IDLE)

func _process(delta):
	match state:
		BossState.IDLE:
			handle_idle(delta)
		BossState.ATTACKING:
			handle_attacking(delta)
		BossState.TAKING_DAMAGE:
			handle_taking_damage(delta)
		BossState.DEAD:
			handle_dead(delta)
	update_attack_timer(delta)

func handle_idle(delta):
	if attack_cooldown == 0:
		set_state(BossState.ATTACKING)

func handle_attacking(delta):
	perform_attack()
	attack_cooldown = attack_timer
	set_state(BossState.IDLE)

func handle_taking_damage(delta):
	if is_taking_damage:
		set_state(BossState.IDLE)
	else:
		set_state(BossState.IDLE)

func handle_dead(delta):
	queue_free() 

func perform_attack():
	pass
	
func set_state(new_state):
	if state != new_state:
		state = new_state
		emit_signal("state_changed", state)
		
func take_damage(amount):
	health -= amount
	if health <= 0 and state != BossState.DEAD:
		set_state(BossState.DEAD)
	else:
		set_state(BossState.TAKING_DAMAGE)
		
func update_attack_timer(delta):
	if attack_cooldown > 0:
		attack_cooldown -= delta
