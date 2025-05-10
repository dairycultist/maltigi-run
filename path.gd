extends Node3D

# https://docs.godotengine.org/en/stable/classes/class_astar3d.html

var astar: AStar3D

func _ready() -> void:
	
	astar = AStar3D.new()
	
	for i in get_child_count():
		astar.add_point(i, get_child(i).global_position)
	
	for i in get_child_count():
		for j in get_child(i).get_meta("neighbors"):
			astar.connect_points(i, j)

func get_next_position(source: Vector3, destination: Vector3) -> Vector3:
	
	var start_point := astar.get_closest_point(source)
	var end_point := astar.get_closest_point(destination)

	var path := astar.get_point_path(start_point, end_point)

	if path.size() > 1:
		return path[1]
	elif path.size() == 1:
		return path[0]
	else:
		return source
