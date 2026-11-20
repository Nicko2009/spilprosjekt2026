
extends StaticBody3D

@onready var building: MeshInstance3D = $"Tinkercad GLTF Scene/Node/Mesh_Mesh_head_geo_001_lambert2SG_001"

func _ready():
	if building == null or building.mesh == null:
		push_error("Fant ikke bygningens mesh!")
		return

	var collision = CollisionShape3D.new()
	collision.shape = building.mesh.create_trimesh_shape()

	add_child(collision)

	collision.global_transform = building.global_transform
