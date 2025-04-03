extends Control

func _ready():
	Player.visible = false;
	Player.canShoot = false;
func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Settings_pressed():
	pass # Replace with function body.
