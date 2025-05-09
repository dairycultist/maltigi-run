extends CharacterBody3D

# probably simplify map shape (mostly boxy = good)
# mapmaking is fun
# CS1 inspired bc ofc https://m.media-amazon.com/images/I/61Qdn31BpAL.jpg

# need a separate mesh for collision
# bot navmesh
# fast paced, wave gameplay

# splash particle effect when landing in water

@export_group("Misc")
@export var camera : Camera3D

@export_group("Movement")
@export var mouse_sensitivity := 0.3

@export var drag := 15
@export var grounded_accel := 160
@export var airborne_accel := 10
@export var flying_accel := 200
@export var jump_speed := 8
@export var max_fall_speed := 32
@export var airborne_course_correction := 0.4

var camera_pitch := 0.0

var is_flying := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("toggle_fly"):
		is_flying = not is_flying
	
	if (position.y < -10):
		position = Vector3.ZERO
		velocity = Vector3.ZERO
	
	# movement
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_flying:
		
		if direction:
			velocity.x += direction.x * flying_accel * delta
			velocity.z += direction.z * flying_accel * delta
			
		if Input.is_action_pressed("jump"):
			velocity.y += flying_accel * delta
		
		if Input.is_action_pressed("crouch"):
			velocity.y -= flying_accel * delta
			
		velocity = lerp(velocity, Vector3.ZERO, delta * drag)
		
	else:
	
		if (velocity.y > -max_fall_speed):
			velocity += get_gravity() * 2.5 * delta
		
		if Input.is_action_pressed("jump") and is_on_floor():
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
			
			# make planar velocity slerp towards forward
			# assuming we're already moving forwards quickly
			var forward := -get_global_transform().basis.z
			var forward_speed := Vector2(velocity.x, velocity.z).dot(Vector2(forward.x, forward.z))
			
			if forward_speed > 5: # yea 5 is hardcoded (it's also used in planar calculation)
				var speed := Vector2(velocity.x, velocity.z).length()
				var planar := Vector3(velocity.x, 0, velocity.z).normalized().slerp(forward, airborne_course_correction * (speed - 5) * delta) * speed
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
