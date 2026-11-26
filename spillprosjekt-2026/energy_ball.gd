extends Area3D

var shooter: Node = null
@export var speed: float = 25.0
var direction: Vector3 = Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	

func setup(target_direction: Vector3, shooter_node: Node = null):
	direction = target_direction.normalized()
	shooter = shooter_node
	

func _physics_process(delta):
	global_position += direction * speed * delta
	look_at(global_position + direction, Vector3.UP)

func _on_body_entered(body):
	if shooter == null:
		return
		
	if shooter.is_in_group("player"):
		if body.is_in_group("enemy"):
			if body.has_method("take_damage"):
				body.take_damage(20)
				queue_free()
	
	elif shooter.is_in_group("enemy"):
		if body.is_in_group("player"):
			body.take_damage(20)
			queue_free()
		
