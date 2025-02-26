extends Node


var bullet = preload("res://Bullet.tscn");
var bullets = []
func create_bullet(position, dir, speed, damage, team):
	var new_bullet = bullet.instance()
	new_bullet.direction = dir;
	new_bullet.position = position
	new_bullet.speed = speed;
	new_bullet.damage = damage;
	new_bullet.team = team;
	get_tree().current_scene.add_child(new_bullet);
	new_bullet.look_at(position+dir);
	# add bullets to new var and store thatinstead
	
