extends Node3D

const PLATFORM = preload("res://platform.tscn")
const DIAMETER_TO_HEIGHT = sqrt(3) / 2.0

@export var hex_diameter := 17.32
@export var map_size := 4

func _ready() -> void:
	
	var random := RandomNumberGenerator.new()
	
	for x in range(1 - map_size, map_size):
		for z in range(1 - map_size, map_size):
			
			if abs(x + z) >= map_size and abs(x - z) <= map_size / 2:
				continue
		
			var platform = PLATFORM.instantiate()
			add_child(platform)
			platform.position = Vector3(
				(x + z * 0.5) * hex_diameter,
				random.randf_range(3.0, 20.0),
				z * hex_diameter * DIAMETER_TO_HEIGHT
			)
			platform.rotation = Vector3(0, PI / 3.0 * random.randi_range(0, 6), 0)
