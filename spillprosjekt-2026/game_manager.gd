extends Node

@export var enemy_scene: PackedScene

var total_enemies = 10
var remaining_enemies = 10

@onready var enemy_counter = $CanvasLayer/EnemyCounter
func _ready():
	add_to_group("game_manager")

	print("GameManager startet!")

	enemy_counter.text = "Enemies left: 10"

	var spawn_points = $EnemySpawns.get_children()
	
	for point in spawn_points:
		print(point.name, " lokal: ", point.position)
		print(point.name, " global: ", point.global_position)

	print("Antall spawn-punkter: ", spawn_points.size())
	

	for i in range(min(total_enemies, spawn_points.size())):
		var enemy = enemy_scene.instantiate()
		$EnemySpawns.add_child(enemy)
		enemy.position = spawn_points[i].position
		
func enemy_defeated():
	remaining_enemies -= 1
	print("Enemies igjen: ", remaining_enemies)
	enemy_counter.text = "Enemies left: " + str(remaining_enemies)

	if remaining_enemies <= 0:
		print("Alle enemies er beseiret!")
