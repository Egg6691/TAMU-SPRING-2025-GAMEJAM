extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sounds = {
	"shoot" : preload("res://Sounds/gun_fire2.mp3"),
	"reload" : preload("res://Sounds/gun_fire.mp3")
}

# Called when the node enters the scene tree for the first time.
func _play_sound(sound, bus_name="Master"):
	if sounds.has(sound):
		var audio_player = AudioStreamPlayer.new()
		audio_player.volume_db -=10
		audio_player.stream = sounds[sound];
		audio_player.bus = bus_name
		add_child(audio_player) 
		audio_player.play()
		yield(get_tree().create_timer(audio_player.stream.get_length()), "timeout")
		audio_player.queue_free()
