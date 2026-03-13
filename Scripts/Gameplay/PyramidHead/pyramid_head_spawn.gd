extends Node

@export var spawnPoints:Array[Node3D]
@export var pyramidHead:PyramidHead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetRandomLocation()
	pass # Replace with function body.
	
func SetRandomLocation():
	var spawn := spawnPoints[randi_range(0,spawnPoints.size()-1)]
	pyramidHead.global_position = spawn.global_position
	pass
