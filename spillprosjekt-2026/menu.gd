extends Node2D


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://3DSpillet.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://totorial.tscn")

func _ready():
	MusicPlayer.play_music(preload("res://assets/Endelig mappe/Musikk/Før \"Play\"/atlasaudio-tension-trailer-613494.mp3"))
