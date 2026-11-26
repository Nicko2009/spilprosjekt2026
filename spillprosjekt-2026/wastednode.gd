extends Node2D

func _on_play_again_pressed():
	print("PLAY AGAIN BLE TRYKKET!")

	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var result = get_tree().change_scene_to_file("res://menu.tscn")
	print("Scene-feil:", result)
