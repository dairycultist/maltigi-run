extends Node3D

const PATH := preload("res://path.tscn")

func _ready() -> void:
	
	var map = [
		[1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 0, 1, 1, 1],
		[0, 0, 0, 1, 0, 1, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 1, 0, 0, 0, 0],
		[1, 0, 0, 1, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 1]
	]
	
	for x in range(8):
		for y in range(8):
	
			if map[x][y] == 1:
				var path = PATH.instantiate()
				add_child(path)
				path.position = Vector3(x * 3, 0, y * 3)
