extends CharacterBody3D

@export var target: Node3D
@export var path: Node3D

var path_position: Vector3

func _ready() -> void:
	path_position = global_position

func _process(delta: float) -> void:
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += get_gravity() * delta
	
	var move: Vector3
	
	move = path_position - global_position
	move = 5.0 * Vector3(move.x, 0, move.z).normalized()
	
	if path_position.distance_to(global_position) < 0.1:
	
		path_position = path.get_next_position(global_position, target.global_position)
		
		if path_position.distance_to(global_position) < 1:
			move = Vector3.ZERO
	
	velocity.x = move.x
	velocity.z = move.z
	
	move_and_slide()

func on_shot():
	queue_free()
