extends Boss
var bullet_speed = 200;
var damage = 5;
func _ready():
	attack_patterns = [];
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
			BulletManager._create_ring(position, Vector2.ZERO, 64*10, damage, "enemy", "homing", Player.position, 8);
		2:
			BulletManager._create_ring(position, Vector2.ZERO, bullet_speed, damage, "enemy", "straight", Player.position, 16);
			
		
