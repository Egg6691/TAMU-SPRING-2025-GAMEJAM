extends Boss
var bullet_speed = 200;
var damage = 5;
func _ready():
	attack_patterns = [];
	get_node("AttackTimer").start()
	
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
	var fasthomer = {
		"direction": Vector2.ZERO,
		"speed": 64 * 6,
		"damage": damage,
		"team": "enemy",
		"type": "homing",
		"target": Player.position
	}
	var bullet = {
		"direction": Vector2.ZERO,
		"speed": 64 * 3,
		"damage": damage,
		"team": "enemy",
		"type": "straight",
		"target": Player.position
	}
	match rand:
		1:
			BulletManager._create_ring(position, fasthomer, 8, 0);
		2:
			for i in range(16):
				BulletManager._create_ring(position, bullet, 16, i*25);
				yield(get_tree().create_timer(0.3), "timeout")
			
		


func _on_AttackTimer_timeout():
	_attack_bullet()
