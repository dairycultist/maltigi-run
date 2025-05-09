extends CharacterBody3D

# probably simplify map shape (mostly boxy = good)
# mapmaking is fun
# CS1 inspired bc ofc https://m.media-amazon.com/images/I/61Qdn31BpAL.jpg

# need a separate mesh for collision
# bot navnodes
# fast paced, wave gameplay

var random = RandomNumberGenerator.new()

var camera_pitch := 0.0
var is_flying := false

@export_group("Gun")
@export var firerate := 12
@export var audiostream_fire : AudioStreamPlayer3D

var fire_cooldown_remaining := 0.0

@export_group("Movement")
@export var mouse_sensitivity := 0.3

@export var drag := 15.0
@export var grounded_accel := 160.0
@export var airborne_accel := 10.0
@export var jump_speed := 8.0
@export var flying_speed := 20.0
@export var max_fall_speed := 32.0
@export var airborne_course_correction := 0.4

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	
	# fly
	if Input.is_action_just_pressed("toggle_fly"):
		is_flying = not is_flying
		velocity = Vector3.ZERO
	
	# kill floor
	if (position.y < -10):
		position = Vector3(0, 10, 0)
		velocity = Vector3.ZERO
	
	# firing
	if fire_cooldown_remaining <= 0.0:
		
		if Input.is_action_pressed("fire"):
		
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position, $Camera3D.global_position - $Camera3D.get_global_transform().basis.z * 100)
			var result = space_state.intersect_ray(query)
			
			if result and result.collider.has_method("on_shot"):
				result.collider.on_shot()
			
			audiostream_fire.volume_linear = random.randf_range(0.8, 1.0)
			audiostream_fire.pitch_scale = random.randf_range(0.95, 1.05)
			audiostream_fire.play()
			
			fire_cooldown_remaining = 1.0 / firerate
			
	else:
		fire_cooldown_remaining -= delta
	
	# movement
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_flying:
		
		if direction:
			position += direction * flying_speed * delta
			
		if Input.is_action_pressed("jump"):
			position.y += flying_speed * delta
		
		if Input.is_action_pressed("crouch"):
			position.y -= flying_speed * delta
		
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
		
		$Camera3D.rotation.x = deg_to_rad(camera_pitch)
