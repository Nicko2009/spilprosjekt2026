extends Area3D

@export var teleport_position: Vector3

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		body.global_position = teleport_position
	MusicPlayer.play_music(preload("res://assets/Endelig mappe/Musikk/Inni stortinget/ambientaudiovision-follows-dark-ambient-194926.mp3"))
