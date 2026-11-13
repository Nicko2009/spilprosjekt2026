extends CharacterBody3D

@export var max_health: int = 100
var health: int = 100
@export var projectile_scene: PackedScene
@export var detection_range: float = 20.0

@onready var shoot_timer: Timer = $shoot

var player: Node3D


func _ready():
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)


func _physics_process(_delta):
	if player == null:
		var players = get_tree().get_nodes_in_group("player")

		if players.size() > 0:
			player = players[0]

	if player == null:
		return

	var distance = global_position.distance_to(
		player.global_position
	)

	if distance > detection_range:
		return

	look_at(
		Vector3(
			player.global_position.x,
			global_position.y,
			player.global_position.z
		),
		Vector3.UP
	)


func _on_shoot_timer_timeout():
	if player == null or projectile_scene == null:
		return

	if global_position.distance_to(player.global_position) > detection_range:
		return

	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)

	var start_position = global_position + Vector3(0, 1, 0)
	projectile.global_position = start_position

	var target_position = player.global_position + Vector3(0, 1, 0)
	var direction = (target_position - start_position).normalized()

	projectile.setup(direction)

func take_damage(amount: int):
	health -= amount
	print("Enemy har", health, "liv igjen")

	if health <= 0:
		print("Enemy er beseiret")
		queue_free()
