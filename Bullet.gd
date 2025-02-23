extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200
var direction = Vector2.ZERO
var team = "none";
var damage = 1;

# Called when the node enters the scene tree for the first time.
func _process(delta):
	position += direction*speed*delta;
	
func _ready():
	add_to_group(team);
	
