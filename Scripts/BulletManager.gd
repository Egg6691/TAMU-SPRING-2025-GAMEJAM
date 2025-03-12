extends Node


var bullet = preload("res://Scenes/Bullets/Bullet.tscn");
var reuse_bullets = [] # these bullets are reused after going offscreen.
var stored_bullets = [] # these are properties to be added to new bullets when they're brought back by tiem mechanic.
func _create_bullet(position, dir, speed, damage, team):
	var new_bullet = bullet.instance()
	new_bullet.direction = dir;
	new_bullet.position = position
	new_bullet.speed = speed;
	new_bullet.damage = damage;
	new_bullet.team = team;
	get_tree().current_scene.add_child(new_bullet);
	new_bullet.look_at(position+dir);
	if team == "player":
		stored_bullets.append(new_bullet);
		
		
	# add bullets to new var and store thatinstead
	

