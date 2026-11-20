extends Area3D

@export var teleport_position: Vector3

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		body.global_position = teleport_position
