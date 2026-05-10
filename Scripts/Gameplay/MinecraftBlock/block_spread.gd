class_name BlockSpread

extends Node3D

@export var block:Block
@export var blockScene:PackedScene
@export var sideBlock:bool = false
@export var blockSize:float = 0.3

@export var excludeCollisions:CollisionObject3D
@export var raycasts:Array[RayCast3D]

var canUpdate:bool = true
var currentRaycastIndex:int = 0
var blockManager:BlockManager

# !! TO DO TO IMPROVE THIS SYSTEM !!
#Creer une class enfant pour le bloc
#Avoir une variable de position
#En fonction de ca, changer les check d'empty space
#Ex: quand position Right >>> check d'abord la droite, 
# si droite pas empty deviens full block 
# sinon commence a se spread uniquement en bas.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cast in raycasts:
		cast.add_exception(excludeCollisions)
	blockManager = Manager.gameManager.block_manager
	Manager.gameManager.FightEnd.connect(StopSpread)
	#blockScene = load(blockScene.resource_path)
	#blockManager.BlockTicked.connect(SpreadUpdate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func SpreadUpdate():
	if(!canUpdate):return
	
	var spawnedBlock:int = 0
	var raycast := raycasts[currentRaycastIndex]
	if(!raycast): return
	var isEmpty := CheckEmptySpace(raycast)
	
	if(isEmpty):
		var spawnPos:Vector3 = owner.global_position + raycast.target_position
		var canSpawn := blockManager.RequestBlockSpawn(spawnPos)
		if(canSpawn):
			SpawnBlock(spawnPos)
			spawnedBlock += 1
	else:
		var col = raycast.get_collider()
		#print("SPREAD BLOCKED BY " + col.owner.name)
		
	if(spawnedBlock >= raycasts.size()):
		print("LOCK UPDATES ON " + str(owner.name))
		canUpdate = false
		
	currentRaycastIndex += 1
	if(currentRaycastIndex >= raycasts.size()): currentRaycastIndex = 0
	
func CheckEmptySpace(raycast:RayCast3D) -> bool:
	return !raycast.is_colliding()
	
	
func SpawnBlock(spawnPosition:Vector3):
	var scene := blockScene.instantiate()
	
	if(scene is Block):
		scene.originBlock = block
		scene.isSide = sideBlock

	get_tree().current_scene.add_child(scene)
	scene.global_position = spawnPosition
	
	print("Spawned New Block : " + str(scene.name))
	pass
	
func StopSpread():
	canUpdate = false
	pass
