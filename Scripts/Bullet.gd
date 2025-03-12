extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200
var direction = Vector2.ZERO
var team = "none";
var damage = 1;
var type = "straight";
var target;
var active = true;
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if active:
		if type == "straight":
			position += direction*speed*delta;
		if type == "homing":
			direction = position.direction_to(target)
			position += direction*speed*delta;
		if type == "swing":
			pass
	
	# doll
	# first phase, homing bullets
	# second phase bullets retrace initial path.
	# maybe multiple body parts to hit
	
	# knight
	# parry mechanic
	# lots of swings
	# maybe immune during some phases
	
	# clock
	# sans undertale end fight esque
	# maybe bring back other attacks
	# maybe retrace player's position (send them back in time)
	# maybe freeze time
	
		
	
func _ready():
	add_to_group(team);
	
