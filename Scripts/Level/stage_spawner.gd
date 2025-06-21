extends Node3D

@export var stagePaths: Array[String] = []
var stages: Array


func PreloadResources():
	for path in stagePaths: 	
		var stage = load(str(path))
		stages.append(stage)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PreloadResources()
	SpawnStage()
	
	
func SpawnStage():
	if(stages.size() <= 0):
		print("NO STAGE LOADED")
		return
	var ranIndex = randi_range(0,stages.size()-1)
	var stage = stages[ranIndex].instantiate()
	add_child(stage)
