extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 50
var direction = Vector2.ZERO
var team = "none";
var damage = 1;
var type = "straight";
var target;
var active = true;
var min_speed;
# Called when the node enters the scene tree for the first time.
func safe_normalize(vec: Vector2) -> Vector2:
	if vec.length() > 0.0001:  # Avoid normalizing a zero-length vector
		return vec.normalized()
	return Vector2.ZERO
func _process(delta):
	if active:
		if type == "straight":
			position += direction*speed*delta;
# Main function to move the bullet (with boid behaviors)
		if type == "homing":
			# Homing behavior: Direction towards the player (existing code)
			var angle = lerp_angle(direction.angle(), position.direction_to(Player.position).angle(), lerp(0, .3, 0.1))
			direction = Vector2(cos(angle), sin(angle))
			speed = lerp(speed, min_speed, 0.02)

			# Boid behaviors (Separation, Alignment, Cohesion)
			var separation_strength = 0.15 # How strongly the bullet avoids other entities
			var alignment_strength = 0.1  # How much the bullet aligns with others
			var cohesion_strength = 0.02  # How much the bullet tries to group with others
			var nearby_boids = BulletManager.reuse_bullets  # Get nearby boids (e.g., bullets or other entities)
			
			var separation_force = Vector2.ZERO
			var alignment_force = Vector2.ZERO
			var cohesion_force = Vector2.ZERO
			var count = 0  # Count of nearby boids
			# Iterate over nearby boids to calculate forces
			for boid in nearby_boids:
				var distance = position.distance_to(boid.position)
				if distance < 15:  # Only consider nearby boids
					count += 1
					
					# Separation: Avoid close proximity to other boids (collisions)
					separation_force += (position - boid.position).normalized() / max(distance, 0.0001);
					
					# Alignment: Align with nearby boid's direction
					alignment_force += boid.direction
					
					# Cohesion: Move towards the average position of nearby boids
					cohesion_force += boid.position
			# Apply forces only if there are nearby boids
			if count > 0:
				separation_force = safe_normalize(separation_force) * separation_strength
				alignment_force = safe_normalize(alignment_force) * alignment_strength
				cohesion_force = safe_normalize((cohesion_force / count) - position) * cohesion_strength
				
				direction += separation_force + alignment_force + cohesion_force
			direction = safe_normalize(direction)

			# Move the bullet using move_and_slide
			move_and_slide(direction * speed)
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
	min_speed = speed / 3.0;
	add_to_group(team);
	
