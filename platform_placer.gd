extends Node3D

const PLATFORM = preload("res://platform.tscn")

@export var hex_diameter := 17.32
const DIAMETER_TO_HEIGHT = sqrt(3) / 2.0

func _ready() -> void:
	
	var random := RandomNumberGenerator.new()
	
	for x in range(-2, 3):
		for z in range(-2, 3):
		
			var platform = PLATFORM.instantiate()
			add_child(platform)
			platform.position = Vector3(
				(x + z * 0.5) * hex_diameter,
				random.randf_range(3.0, 20.0),
				z * hex_diameter * DIAMETER_TO_HEIGHT
			)
			platform.rotation = Vector3(0, PI / 3.0 * random.randi_range(0, 6), 0)
