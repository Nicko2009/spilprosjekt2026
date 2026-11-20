extends Area3D

var shooter: Node = null
@export var speed: float = 8.0
var direction: Vector3 = Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	print("Bullet startet")

func setup(target_direction: Vector3, shooter_node: Node = null):
	direction = target_direction.normalized()
	shooter = shooter_node
	print("Bullet retning:", direction)

func _physics_process(delta):
	global_position += direction * speed * delta
	look_at(global_position + direction, Vector3.UP)

func _on_body_entered(body):
	if shooter == null:
		print("Kulen traff:", body.name, "Grupper:", body.get_groups())
		return
		
	if shooter.is_in_group("player"):
		if body.is_in_group("enemy"):
			if body.has_method("take_damage"):
				body.take_damage(20)
				print("Enemy ble truffet!")
				queue_free()
	
	elif shooter.is_in_group("enemy"):
		if body.is_in_group("player"):
			body.take_damage(20)
			print("player ble truffet")
			queue_free()
		
