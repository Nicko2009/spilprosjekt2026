
extends CharacterBody3D

@export var max_health: int = 100
var health: int = 100

@export var projectile_scene: PackedScene
@export var detection_range: float = 20.0

@export var move_speed: float = 3.0
@export var move_range: float = 2.0

var start_position: Vector3
var move_direction: Vector3 = Vector3.ZERO
var move_timer: float = 0.0

@onready var shoot_timer: Timer = $shoot

var player: Node3D


func _ready():
	add_to_group("enemy")
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	randomize()

	start_position = global_position
	change_direction()


func change_direction():
	var random_choice = randi_range(0, 4)

	match random_choice:
		0:
			move_direction = Vector3(1, 0, 0)
		1:
			move_direction = Vector3(-1, 0, 0)
		2:
			move_direction = Vector3(0, 0, 1)
		3:
			move_direction = Vector3(0, 0, -1)
		4:
			move_direction = Vector3.ZERO

	move_timer = randf_range(1.0, 2.0)


func _physics_process(delta):

	move_timer -= delta

	if move_timer <= 0:
		change_direction()

	var distance_from_start = Vector2(
		global_position.x - start_position.x,
		global_position.z - start_position.z
	).length()

	if distance_from_start >= move_range:
		var return_direction = Vector3(
			start_position.x - global_position.x,
			0,
			start_position.z - global_position.z
		).normalized()

		move_direction = return_direction

	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

	move_and_slide()

	if player == null:
		var players = get_tree().get_nodes_in_group("player")

		if players.size() > 0:
			player = players[0]

	if player == null:
		return

	var distance = global_position.distance_to(
		player.global_position
	)

	if distance <= detection_range:
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

	var bullet_start = global_position + Vector3(0, 1, 0)
	projectile.global_position = bullet_start

	var target_position = player.global_position + Vector3(0, 1, 0)
	var direction = (target_position - bullet_start).normalized()

	projectile.setup(direction, self)
	
	$NpcShoot.play()


func take_damage(amount: int):

	health -= amount
	health = max(health, 0)

	print("Enemy har", health, "liv igjen")

	if health <= 0:
		print("Enemy er beseiret")
		queue_free()
