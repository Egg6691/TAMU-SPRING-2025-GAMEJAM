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
onready var bp = get_node("BulletPosition")
func _ready():
	speed = 200;
	animations = get_node("Sprite/AnimationPlayer")
	perform_attack()
	#_attack_chain()
	

func perform_attack():
	var possible_attacks = []
	if position.distance_to(Player.position) > 0:
		possible_attacks.append(attacks.BULLET1)
		possible_attacks.append(attacks.BULLET2)
		possible_attacks.append(attacks.BULLET3)
		possible_attacks.append(attacks.CHAIN);
	#else:
		#possible_attacks.append(attacks.CHOMP);
	var rand = 0 #possible_attacks[rand_range(0,possible_attacks.size())]; TODO
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
			for i in range(8):
				bp.position = position+25*Vector2(cos(deg2rad((i * 360.0) / 8.0)), sin(deg2rad((i*360.0)/8.0)))
				fasthomer["direction"] = Vector2.RIGHT.rotated(i*PI/4.0)
				BulletManager._create_bullet(bp.position, fasthomer);
				yield(get_tree().create_timer(0.3), "timeout")
		2:
			var offset = rand_range(0,360)
			for i in range(16):
				BulletManager._create_ring(position, bullet, 16, i * 75+offset)
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
