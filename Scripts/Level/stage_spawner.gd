extends Node3D

@export var map:Map
var debugMode = false
var debugSpawnIndex = 0
var stages: Array


func PreloadResources():
	for path in map.stagePaths: 	
		var stage = load(str(path))
		stages.append(stage)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PreloadResources()
	
	debugMode = Manager.gameDebug.debugStage
	debugSpawnIndex = Manager.gameDebug.stageIndex
	
	if(debugMode):
		SpawnStage(debugSpawnIndex)
		return
	
	RandomSpawnStage()
	
func RandomSpawnStage():
	if(stages.size() <= 0):
		print("NO STAGE LOADED")
		return
	var ranIndex = randi_range(0,stages.size()-1)
	
	if(ranIndex == Manager.previousStage):
		RandomSpawnStage()
		return
		
	SpawnStage(ranIndex)

func SpawnStage(stageIndex:int):
	if(stages.size() <= 0):
		print("NO STAGE LOADED")
		return
	var stage = stages[stageIndex].instantiate()
	add_child(stage)
	Manager.previousStage = stageIndex
