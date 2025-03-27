extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var boss = get_parent().get_node("Sword")
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = Player.position.x - clamp(Player.position.x-boss.position.x, -100, 100)
	position.y = Player.position.y - clamp(Player.position.y-boss.position.y, -100, 100)
