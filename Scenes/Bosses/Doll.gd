extends Boss
const pull_strength = 80;

var bullet_speed = 200;
var damage = 5;
var pulling = false;
var direction = Vector2.ZERO;

enum attacks {
	BULLET1,
	BULLET2,
	BULLET3,
	CHAIN,
	CHOMP
}

onready var pulltimer = get_node("ChainPullDuration")
onready var fasthomer = {
	"direction": Vector2.ZERO,
	"speed": 64 * 12,
	"damage": damage,
	"team": "enemy",
	"type": "homing",
	"target": Player.position,
	"sprite": "res://Images/bullet_red_arrow.png"
}
onready var bullet = {
	"direction": Vector2.ZERO,
	"speed": 64 * 3,
	"damage": damage,
	"team": "enemy",
	"type": "straight",
	"target": Player.position,
	"sprite": "res://Images/bullet_orange_small.png"
}
func _ready():
	speed = 200;
	animations = get_node("Sprite/AnimationPlayer")
	perform_attack()
	#_attack_chain()
	
func handle_moving(delta):
	var angle = lerp_angle(direction.angle(), position.direction_to(Player.position).angle(), .02)
	direction = Vector2(cos(angle), sin(angle))
	position+=direction.normalized()*speed*delta;
	if time_in_state > 3.0:
		set_state(BossState.ATTACKING);
	
func perform_attack():
	var possible_attacks = []
	if position.distance_to(Player.position) > 0:
		possible_attacks.append(attacks.BULLET1)
		possible_attacks.append(attacks.BULLET2)
		possible_attacks.append(attacks.BULLET3)
		possible_attacks.append(attacks.CHAIN);
	#else:
		#possible_attacks.append(attacks.CHOMP);
	var rand = possible_attacks[rand_range(0,possible_attacks.size())];
	match rand:
		attacks.BULLET1:
			_attack_bullet(1)
		attacks.BULLET2:
			_attack_bullet(2)
		attacks.BULLET3:
			_attack_bullet(3)
		attacks.CHAIN:
			_attack_chain()
	return 3.0;
func _attack_bullet(num):
	match num:
		1:
			BulletManager._create_ring(position, fasthomer, 8, 0)
		2:
			for i in range(16):
				BulletManager._create_ring(position, bullet, 16, i * 75)
				yield(get_tree().create_timer(0.3), "timeout")
		3:
			for i in range(100):
				BulletManager._create_ring(position, bullet, 1, randi() % 360)
				yield(get_tree().create_timer(0.01), "timeout")

				

func _attack_chain():
	pulling = true;
	pulltimer.start()
	yield(pulltimer, "timeout")
	
func _process(delta):
	._process(delta)
	if pulling:
		Player.e_velocity += pull_strength*(Player.position.direction_to(position))
	
	
func _on_ChainPullDuration_timeout():
	pulling = false;
