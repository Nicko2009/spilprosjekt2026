extends Area3D

@export var teleport_position: Vector3
@export var teleport_rotation: float = 0.0

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		body.global_position = teleport_position
		body.rotation.y = deg_to_rad(teleport_rotation)
				
	MusicPlayer.play_music(preload("res://assets/Endelig mappe/Musikk/Inni stortinget/ambientaudiovision-follows-dark-ambient-194926.mp3"))
