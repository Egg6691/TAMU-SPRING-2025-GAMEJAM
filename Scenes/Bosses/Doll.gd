extends Boss
var bullet_speed = 200;
var damage = 5;
var pulling = false;
const pull_strength = 200;
onready var pulltimer = get_node("ChainPullDuration")
onready var fasthomer = {
	"direction": Vector2.ZERO,
	"speed": 64 * 10,
	"damage": damage,
	"team": "enemy",
	"type": "homing",
	"target": Player.position
}
onready var bullet = {
	"direction": Vector2.ZERO,
	"speed": 64 * 3,
	"damage": damage,
	"team": "enemy",
	"type": "straight",
	"target": Player.position
}
func _ready():
	attack_patterns = [];
	get_node("AttackTimer").start()
	#_attack_chain()
	
func handle_moving(delta):
	position += position.direction_to(Player.position)*speed;
func perform_attack():
	pass
	#if far
		# add far attack
		# add dash
		#if phase 2
			# add more attack
	# if close
		# add close attack
		#if phase 2
			#add more attack
	#pick random attack
	#attack
	#set attack cooldown 
func _attack_bullet():
	var rand = randi() % 3 + 1

	match rand:
		1:
			BulletManager._create_ring(position, fasthomer, 8, 0);
		2:
			for i in range(16):
				BulletManager._create_ring(position, bullet, 16, i*25);
				yield(get_tree().create_timer(0.3), "timeout")
		3:
			for i in range(100):
				BulletManager._create_ring(position, bullet, 1, randi()%360);
				yield(get_tree().create_timer(0.01), "timeout")
				

func _attack_chain():
	pulling = true;
	pulltimer.start()
	yield(pulltimer, "timeout")
	pulling = false;
	
	
func _process(delta):
	._process(delta)
	if pulling:
		Player.e_velocity += pull_strength*(Player.position.direction_to(position))
	
	

func _on_AttackTimer_timeout():
	_attack_bullet()

func _on_ChainPullDuration_timeout():
	pass
	#pulling = false;
