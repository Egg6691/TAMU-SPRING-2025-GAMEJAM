extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 50
var direction = Vector2.ZERO
var team = "none";
var damage = 1;
var type = "straight";
var target;
var active = false;
var min_speed;
var sprite_path;
var indicator_delay = .5;

onready var sprite = get_node("Sprite")
onready var indicator = get_node("Indicator")
onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func safe_normalize(vec: Vector2) -> Vector2:
	if vec.length() > 0.0001:  # Avoid normalizing a zero-length vector
		return vec.normalized()
	return Vector2.ZERO
	
func get_nearby_boids():
	var nearby_boids = []
	for body in get_overlapping_areas():
		if body.is_in_group("bullet"):
			nearby_boids.append(body);
	return nearby_boids;
			
func _process(delta):
	if active:
		match type:
			"straight":
				position += direction*speed*delta;
			"homing":
				var angle = lerp_angle(direction.angle(), position.direction_to(Player.position+Vector2(rand_range(-200,200), rand_range(-200,200))).angle(), lerp(0, .5, 0.1))
				direction = Vector2(cos(angle), sin(angle))
				rotation = angle - PI/2
				speed = lerp(speed, min_speed, 0.02)
				var separation_strength = .075 # How strongly the bullet avoids other entities
				var alignment_strength = 0.1  # How much the bullet aligns with others
				var cohesion_strength = 0.02  # How much the bullet tries to group with others
				var nearby_boids = get_nearby_boids();  # Get nearby boids (e.g., bullets or other entities)
				
				var separation_force = Vector2.ZERO
				var alignment_force = Vector2.ZERO
				var cohesion_force = Vector2.ZERO
				var count = 0  # Count of nearby boids
				# Iterate over nearby boids to calculate forces
				for boid in nearby_boids:
					var distance = position.distance_to(boid.position)
					count += 1
					separation_force += (position - boid.position).normalized() / max(distance, 0.0001);
					alignment_force += boid.direction
					cohesion_force += boid.position
				# Apply forces only if there are nearby boids
				if count > 0:
					separation_force = safe_normalize(separation_force) * separation_strength
					alignment_force = safe_normalize(alignment_force) * alignment_strength
					cohesion_force = safe_normalize((cohesion_force / count) - position) * cohesion_strength
					
					direction += separation_force + alignment_force + cohesion_force
				direction = safe_normalize(direction)

				# Move the bullet using move_and_slide
				position += direction.normalized()*speed*delta
				#move_and_slide(direction * speed)
			"swing":
				pass
			"beam":
				active = false;
				sprite.offset.x = sprite.texture.get_width()/2
				sprite.position.x += speed*15
				sprite.scale.x = speed*30
				sprite.scale.y = 15;
				
func _create_indicator():
	sprite.visible = false;
	indicator.scale.x = speed*30
	yield(get_tree().create_timer(indicator_delay), "timeout")
	sprite.visible = true;
	active = true;
	indicator.visible = false;
	timer.start();

func _ready():
	add_to_group("bullet")
	if min_speed == null:
		min_speed = speed / 2.0;
	add_to_group(team);
	timer.start();
	if sprite_path != null:
		sprite.texture = load(sprite_path);
	if indicator_delay > 0: # TODO: ADD BOOLEAN
		_create_indicator()
	else:
		timer.start();
		active = true


func _on_Timer_timeout():
	queue_free()
