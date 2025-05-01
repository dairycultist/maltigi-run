extends CharacterBody3D

# what if battle royale https://www.youtube.com/watch?v=LG2eXmozbH8
# water shader that uses depth texture to make shallow areas more translucent
# each hexagon has a cutout for a ladder (goes all the way down to water!)
# hexagons are made of concrete. ladder is probably a nice bright orange.
# maybe cutout is a bit wider than ladder, so up top there's a grate to either
# side to make it look nice
# need a separate mesh for collision
# fast paced gameplay

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
	
	if (position.y < -10):
		position = Vector3.ZERO
		velocity = Vector3.ZERO
	
	# movement
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if (velocity.y > -max_fall_speed):
		velocity += get_gravity() * 2.5 * delta
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
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
	else:
		# make planar velocity forward only
		var forward = -get_global_transform().basis.z
		var planar = Vector3(forward.x, 0, forward.z) * Vector2(velocity.x, velocity.z).length()
		velocity.x = planar.x
		velocity.z = planar.z
	
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
