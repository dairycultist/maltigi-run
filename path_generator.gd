extends Node3D

const PATH := preload("res://path.tscn")

# boobcoin collecting
# enemy chasing you
# transportation to shop upon getting all boobcoin
# items/modifiers
# more enemies, randomly selected from (ex. one that makes all platforms icey)

const PATH_SIZE := 3
const MAZE_SIZE := 15

func _ready() -> void:
	
	var map = []
	
	# instantiate
	for x in range(MAZE_SIZE):
		map.append([])
		for y in range(MAZE_SIZE):
			map[x].append(false)
	
	# generaze maze with randomized depth-first search
	var stack = [ Vector2i(0, 0) ]
	map[0][0] = true
	
	while not stack.is_empty():
		
		var current = stack.back()
		var possible_directions = []
		
		if current.x - 2 >= 0 and not map[current.x - 2][current.y]:
			possible_directions.append(Vector2i(-1, 0))
			
		if current.x + 2 < MAZE_SIZE and not map[current.x + 2][current.y]:
			possible_directions.append(Vector2i(1, 0))
			
		if current.y - 2 >= 0 and not map[current.x][current.y - 2]:
			possible_directions.append(Vector2i(0, -1))
			
		if current.y + 2 < MAZE_SIZE and not map[current.x][current.y + 2]:
			possible_directions.append(Vector2i(0, 1))
		
		# push a random neighbor that hasn't already been built
		# if you can't, pop
		if possible_directions.is_empty():
			stack.pop_back()
		else:
			var chosen_direction = possible_directions.pick_random()
			stack.push_back(current + chosen_direction * 2)
			map[current.x + chosen_direction.x    ][current.y + chosen_direction.y    ] = true
			map[current.x + chosen_direction.x * 2][current.y + chosen_direction.y * 2] = true
			
		
	
	
	# generate all paths
	for x in range(MAZE_SIZE):
		for y in range(MAZE_SIZE):
	
			if map[x][y]:
				var path = PATH.instantiate()
				add_child(path)
				path.position = Vector3(x * PATH_SIZE, 0, y * PATH_SIZE)
