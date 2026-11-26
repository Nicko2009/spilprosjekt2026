extends Node2D


func _on_play_again_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://3DSpillet.tscn")
