extends Node


const EVANGELION_MAP = preload("res://Scenes/Maps/Maps/evangelion_map.tscn")
const TEST_MAP = preload("res://Scenes/Maps/Maps/Test_map.tscn")
const SILENT_HILL_MAP = preload("res://Scenes/Maps/Maps/SilentHill_map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func InstantiateMap(mapName:String) -> Node:
	var instance
	match mapName:
		"Evangelion":
			print("eva map instance")
			instance = EVANGELION_MAP.instantiate()
		"Beach":
			print("beach map instance")
			instance = TEST_MAP.instantiate()
		"SilentHill":
			print("Silent Hill map instance")
			instance = SILENT_HILL_MAP.instantiate()

	return instance
