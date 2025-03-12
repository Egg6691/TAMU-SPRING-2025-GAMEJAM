extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("PlayerTrackerTimer");
onready var player = get_node("Player")
var player_pos = [];
# Called when the node enters the scene tree for the first time.
func _track_position():
	timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	


func _append_position():
	player_pos.append(player.position);
	print(player_pos)
