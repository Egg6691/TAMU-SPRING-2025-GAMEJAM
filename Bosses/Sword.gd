extends Boss

var vulnerable = false;
var damage = 5;
var step_distance = speed / 5
var swinging
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bp = get_node("BulletPosition")
enum attacks {
	SWING,
	PARRY,
	SPIN,
	SPIN2,
	DASH
}
onready var swing = {
	"direction": Vector2.ZERO,
	"speed": 64*.25,
	"damage": damage,
	"team": "enemy",
	"type": "swing",
	"target": Player.position,
	"sprite": "res://Images/Sword Slash Png - Plot PNG Transparent With Clear Background ID 164277 _ TopPNG (1).jpg",
	"lifetime": .3
}

func _ready():
	idle_time = .5

func _process(delta):
	if !swinging:
		rotation = 0;
	if swinging and state == BossState.ATTACKING:
		var distance = position.distance_to(Player.position)
		var target_direction = position.direction_to(Player.position)
		var turn_speed = clamp(distance / 300, 0.4, 1.0)
		velocity = lerp(velocity, target_direction * speed * 16, turn_speed * delta)
		move_and_slide(velocity)
		rotation +=1;
func perform_attack():
	swinging = false;
	var possible_attacks = []
	if position.distance_to(Player.position) > 100:
		possible_attacks.append(attacks.DASH)
		possible_attacks.append(attacks.SPIN2)
	else:
		possible_attacks.append(attacks.SWING)
		possible_attacks.append(attacks.SPIN)
	var rand = 0 #possible_attacks[rand_range(0,possible_attacks.size())]; TODO
	match rand:
		attacks.SWING:
			_swing(rand_range(1,5));
		attacks.SPIN:
			_spin();
		attacks.SPIN2:
			_spin2();
			return 6.0
		attacks.DASH:
			_dash();
	return 3.0;

func _swing(swings):
	for i in range(swings):
		var dir = position.direction_to(Player.position)
		bp.position = Vector2(position.x + dir.x*3*step_distance, position.y)
		swing["direction"] = dir
		BulletManager._create_bullet(bp.position, swing)
		yield(get_tree().create_timer(0.2), "timeout")
		var tween = Tween.new()
		add_child(tween)
		var new_position = position + dir * step_distance
		tween.interpolate_property(self, "position", position, new_position, 0.15, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")  #
		tween.queue_free() 
		yield(get_tree().create_timer(0.1), "timeout")
	
func _spin():
	pass
func _spin2():
	swinging = true;
	#var anglerp = clamp(position.distance_to(Player.position)/1000, 0, 1)
	
	
func _dash():
	pass
