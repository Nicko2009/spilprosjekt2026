extends CharacterBody3D
 
@export var projectile_scene: PackedScene
@export var max_health: int = 150
var health: int = 150
@export var wasted_scene: PackedScene 
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.001
 
@onready var head: Node3D = $Head
@onready var health_bar: ProgressBar = $CanvasLayer/Control/HealthBar
@onready var camera = $Head/Camera3D
@onready var damage = $CanvasLayer/damage
@onready var flash = get_tree().current_scene.find_child("flash", true, false) 
 
var gravity: float = ProjectSettings.get_setting(
    "physics/3d/default_gravity"
)
 
var camera_pitch: float = 0.0
 
func _ready():
	add_to_group("player")
	global_position = get_parent().get_node("Marker3D").global_position
	$FootstepTimer.timeout.connect(_on_footstep_timer_timeout)
	global_position = get_parent().get_node("Marker3D").global_position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Head/Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()
	health_bar.max_value = max_health
	health_bar.value = health
 
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivity)
 
			camera_pitch -= event.relative.y * mouse_sensitivity
			camera_pitch = clamp(
				camera_pitch,
				deg_to_rad(-85),
				deg_to_rad(85)
			)
 
			head.rotation.x = camera_pitch
 
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
 
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				shoot()
 
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
 
	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
 
 
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
 
	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
        "move_backward"
	)
 
	var direction = (
		transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()
 
	var speed = walk_speed
 
	if Input.is_key_pressed(KEY_SHIFT):
		speed = sprint_speed
 
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)
	move_and_slide()
	
	$Head/Camera3D/SubViewportContainer/SubViewport/view_model_camera.global_transform = camera.global_transform
	
	if is_on_floor() and Vector2(velocity.x, velocity.z).length() > 0.2:
		if $FootstepTimer.is_stopped():
			$FootstepTimer.start()
	else:
		$FootstepTimer.stop()
 
func take_damage(amount: int):
	health -= amount
	health = max(health, 0)	
 
	health_bar.value = health
	show_damage()
 
	if health <= 0:
		die()
	
func show_damage():
	damage.color = Color(1, 0, 0, 0.4)

	var tween = create_tween()
	tween.tween_property(
		damage,
		"color:a",
		0.0,
		0.3
	)
	
func shoot():
	if projectile_scene == null:
		return
 
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
 
	var camera = head.get_node("Camera3D")
	var direction = -camera.global_transform.basis.z
	
	var start_position = camera.global_position + direction * 1.5
 
	projectile.global_position = start_position
	projectile.setup(direction, self)
	$ShootSound.play()
	
	if flash:
		flash.global_position =camera.global_position + direction * 1.5
		flash.visible = true
		await get_tree().create_timer(0.05).timeout
		flash.visible = false
	
	
func die():
	print("Player døde!")
	var wasted_scene = load("res://wastednode.tscn")
	var wasted = wasted_scene.instantiate()
	get_tree().current_scene.add_child(wasted)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
 
func _on_footstep_timer_timeout():
	$FootstepSound.play()
