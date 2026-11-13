extends Area3D

@export var speed: float = 8.0
var direction: Vector3 = Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

func setup(target_direction: Vector3):
	direction = target_direction.normalized()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
