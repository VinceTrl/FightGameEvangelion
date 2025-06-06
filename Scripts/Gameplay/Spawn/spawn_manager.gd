class_name SpawnManager
extends Node

@export var randomSpawnDelayMin = 2.0
@export var randomSpawnDelayMax = 5.0
@export var items: Array[SpawnableItem] = []

var spawners: Array[Spawner] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.spawnManager = self
	PreloadResources()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func PreloadResources():
	for item in items: 	
		item.resource = load(str(item.scenePath))	

func TimerRandomSpawn():
	var timerDuration = randf_range(randomSpawnDelayMin,randomSpawnDelayMax)
	await get_tree().create_timer(timerDuration,true,false,true).timeout
	RandomSpawn()
	TimerRandomSpawn()
	
func RegisterSpawner(_spawnerToAdd: Spawner):
	if(spawners.has(_spawnerToAdd)): return
	spawners.append(_spawnerToAdd)
	
func RandomSpawn():
	var spawner: Spawner = PickRandomSpawner()
	#print(str(spawner))
	var _itemToSpawn = PickRandomItem()
	spawner.SpawnExternalItem(_itemToSpawn)
	#print("spawning : " + str(_itemToSpawn.resource_name))
	
func PickRandomSpawner() -> Spawner:
	var ranIndex = randi_range(0,spawners.size()-1)
	return spawners[ranIndex]
	
func PickRandomItemOnSpawner(_spawner : Spawner) -> StringName:
	randomize()
	var ranIndex = randi_range(0,_spawner.items.size()-1)
	#print("items max range : " + str(_spawner.items.size()-1))
	#print("index : " + str(ranIndex))
	return _spawner.items[ranIndex].itemName
	
func PickRandomItem() -> SpawnableItem:
	randomize()
	var ranIndex = randi_range(0,items.size()-1)
	#print("items max range : " + str(items.size()-1))
	#print("index : " + str(ranIndex))
	return items[ranIndex]
