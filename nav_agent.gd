extends CharacterBody3D

@export var target : Node3D
@export var path : Node3D

func _process(delta: float) -> void:
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += get_gravity() * delta
	
	var path_position: Vector3 = path.get_next_position(global_position, target.global_position)
	
	var move: Vector3
	
	if path_position.distance_to(global_position) > 1:
	
		move = path_position - global_position
		move = 5.0 * Vector3(move.x, 0, move.z).normalized()
	else:
		move = Vector3.ZERO
	
	velocity.x = move.x
	velocity.z = move.z
	
	move_and_slide()
