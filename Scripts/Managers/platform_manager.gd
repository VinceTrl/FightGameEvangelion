extends Node

@export var platforms: Array[MovingPlatform] = []
@export var timeBetweenTest: float = 10
@export var platformSpawnChance:float = 0.5
@export var platformCountMin:int  = 1
@export var platformCountMax:int  = 2


var activePlatforms: Array[MovingPlatform] = []
var canSpawnPlatform = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CallPlatformTimer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func RegisterPlatform(_platform:MovingPlatform):
	platforms.append(_platform)
	print("REGISTER PLATFORM")
	
func SpawnTest() -> bool:
	randomize()
	var random = randf_range(0.0,1.0)
	return random <= platformSpawnChance
	
func CallPlatformTimer():
	await get_tree().create_timer(timeBetweenTest,true,false,false).timeout
	CallPlatform()
	
	
func CallPlatform():
	if(!canSpawnPlatform): return
	
	if(!SpawnTest()):
		print("TEST SPAWN FAILED")
		CallPlatformTimer()
		return

	var count = randi_range(platformCountMin,platformCountMax)
	var platformsSelection: Array[MovingPlatform] = platforms.duplicate()
	
	
	for c in range(count):
		var platform = PickRandomPlatformOnArray(platformsSelection)
		platformsSelection.erase(platform)
		platform.EnterArena()
		
		
		#need to connect the platform to signal to remove the platform from the active array
		#activePlatforms.append(platform)
		#platform.OnPlatformExit.connect(RemovePlatformFromActive(platform))
		
	CallPlatformTimer()
	
	
func RemovePlatformFromActive(platformToRemove: MovingPlatform):
	if(!activePlatforms.has(platformToRemove)): return
	activePlatforms.erase(platformToRemove)
	
func PickRandomPlatformOnArray(_platforms: Array[MovingPlatform]) -> MovingPlatform:
	randomize()
	var ranIndex = randi_range(0,_platforms.size()-1)
	return _platforms[ranIndex]
