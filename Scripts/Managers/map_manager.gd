extends Node

@export var maps: Array[Map] = []
@export var debugMode = false
@export var debugSpawnIndex = 0
var mapsLoaded: Array

func PreloadAllResources():
	for map in maps: 	
		var load = load(str(map.mapScenePath))
		mapsLoaded.append(load)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#PreloadAllResources()
	
	if(debugMode):
		SpawnMap(debugSpawnIndex)
		return
	
	RandomSpawnMap()
	
	
func RandomSpawnMap():
	if(maps.size() <= 0):
		print("NO MAP LOADED")
		return
	var ranIndex = randi_range(0,maps.size()-1)
	SpawnMap(ranIndex)

func SpawnMap(mapIndex:int):
	if(maps.size() <= 0):
		print("NO MAP ASSIGNED")
		return
		
	if(mapIndex >= maps.size()):
		print("WRONG MAP INDEX")
		return
		
	var mapData = load(str(maps[mapIndex].mapScenePath))
	var map = mapData.instantiate()
	add_child(map)
