extends Node3D

const PLATFORM = preload("res://platform.tscn")

@export var hex_diameter := 17.32
const DIAMETER_TO_HEIGHT = sqrt(3) / 2.0

func _ready() -> void:
	
	for x in range(-2, 3):
		for z in range(-2, 3):
		
			var platform = PLATFORM.instantiate()
			add_child(platform)
			platform.position = Vector3((x + z * 0.5) * hex_diameter, 0, z * hex_diameter * DIAMETER_TO_HEIGHT)
