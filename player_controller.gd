extends CharacterBody3D

@export_group("Misc")
@export var camera : Camera3D

@export_group("Movement")
@export var mouse_sensitivity := 0.3

@export var drag := 8
@export var grounded_accel := 50
@export var airborne_accel := 10
@export var jump_speed := 8
@export var max_fall_speed := 32

var camera_pitch := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	
	# movement
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if (velocity.y > -max_fall_speed):
		velocity += get_gravity() * 2.5 * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed
	
	if direction:
		
		if is_on_floor():
			velocity.x += direction.x * grounded_accel * delta
			velocity.z += direction.z * grounded_accel * delta
		else:
			velocity.x += direction.x * airborne_accel * delta
			velocity.z += direction.z * airborne_accel * delta
	
	if is_on_floor():
		velocity = lerp(velocity, Vector3.ZERO, delta * drag)
		
	move_and_slide()


func _input(event):
	
	if event.is_action_pressed("pause"):
		
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		
		rotation.y += deg_to_rad(-event.relative.x * mouse_sensitivity)
		
		camera_pitch = clampf(camera_pitch - event.relative.y * mouse_sensitivity, -90, 90)
		
		camera.rotation.x = deg_to_rad(camera_pitch)
