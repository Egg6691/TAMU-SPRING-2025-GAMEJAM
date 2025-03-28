extends Node


var bullet = preload("res://Scenes/Bullets/Bullet.tscn");
var reuse_bullets = [] # these bullets are reused after going offscreen.
var stored_bullets = [] # these are properties to be added to new bullets when they're brought back by tiem mechanic.
func _create_bullet(position, properties: Dictionary):
	var new_bullet = bullet.instance()
	
	new_bullet.position = position
	new_bullet.direction = properties.get("direction", Vector2())
	new_bullet.speed = properties.get("speed", 400)
	new_bullet.damage = properties.get("damage", 10)
	new_bullet.team = properties.get("team", "player")
	new_bullet.type = properties.get("type", "standard")
	new_bullet.target = properties.get("target", null)
	new_bullet.scale.x = properties.get("scale", 1.0)
	new_bullet.scale.y = properties.get("scale", 1.0)
	new_bullet.sprite_path = properties.get("sprite", "res://icon.png")
	new_bullet.indicator_delay = properties.get("indicator_delay", 0)
	get_tree().current_scene.call_deferred("add_child", new_bullet) # TODO: not sure if this is needed in final.
	new_bullet.lifetime = properties.get("lifetime", 3);
	new_bullet.rotation = properties.get("rotation", 0);
	new_bullet.look_at(position + new_bullet.direction)
	reuse_bullets.append(new_bullet);
	if new_bullet.team == "player":
		stored_bullets.append(new_bullet)
		
func _create_ring(position, properties: Dictionary, number, offset):
	for i in range(number):
		properties["direction"] = Vector2(cos(deg2rad((i * 360.0+offset) / number)), sin(deg2rad((offset+i*360.0)/number)))
		_create_bullet(position, properties);
	# add bullets to new var and store thatinstead
	

