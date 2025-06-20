class_name SpawnManager
extends Node

@export var randomSpawnDelayMin = 2.0
@export var randomSpawnDelayMax = 5.0
@export var items: Array[SpawnableItem] = []
@export var canSpawn = true

var spawners: Array[Spawner] = []
var spawnableItems: Array[SpawnableItem] = []
var uniqueInstances: Array[SpawnableItem] = []

var spawned_instances = {} # Dictionnary of unique instances

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.spawnManager = self
	Manager.OnFightFinish.connect(StopSpawnerSystem)
	#spawnableItems = items
	PreloadResources()
	SetSpawnArray()
	print("SIZE : " + str(spawnableItems.size()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func SetSpawnArray():
	for item in items:
		print("Item: " + str(item.itemName))
		print("Spawn chance: " + str(item.spawnChance))
		for i in range(item.spawnChance):
			AddItemInSpawnArray(item)

func AddItemInSpawnArray(itemToAdd : SpawnableItem):
	spawnableItems.append(itemToAdd)
	
func PreloadResources():
	for item in items: 	
		item.resource = load(str(item.scenePath))

func TimerRandomSpawn():
	var timerDuration = randf_range(randomSpawnDelayMin,randomSpawnDelayMax)
	await get_tree().create_timer(timerDuration,true,false,true).timeout
	RandomSpawn(PickRandomSpawner())
	TimerRandomSpawn()
	
func RegisterSpawner(_spawnerToAdd: Spawner):
	if(spawners.has(_spawnerToAdd)): return
	spawners.append(_spawnerToAdd)
	print("SPAWNER REGISTERED")
	
func RandomSpawn(spawner: Spawner):
	if(!canSpawn):return
	
	if(spawner == null):
		push_error("NULL SPAWNER ON RANDOM SPAWN")
		return
		
	#var spawner: Spawner = PickRandomSpawner()
	#print(str(spawner))
	var _itemToSpawn = PickRandomItem()
	
	#check if it's an unique instance already spawned
	if(_itemToSpawn.isUniqueInstance):
		for spawnable_item in spawned_instances.keys():
			if spawned_instances[spawnable_item] == _itemToSpawn:
				#it's already spawned >>> restart spawn and cancel current function
				RandomSpawn(spawner) 
				return
				
	#check if it's an unique spawn
	if(_itemToSpawn.spawnOncePerGame):
		EraseItemFromSystem(_itemToSpawn)
		
	var instance = spawner.SpawnExternalItem(_itemToSpawn)
	
	if(instance is Node and _itemToSpawn.isUniqueInstance):
		instance as Node
		spawned_instances[instance] = _itemToSpawn
		instance.tree_exited.connect(Callable(self, "RemoveUniqueInstance").bind(instance))
	
	#print("spawning : " + str(_itemToSpawn.resource_name))
	
func PickRandomSpawner() -> Spawner:
	var ranIndex = randi_range(0,spawners.size()-1)
	print("pick spawner : " + str(spawners[ranIndex]))
	return spawners[ranIndex]
	
func PickRandomItemOnSpawner(_spawner : Spawner) -> StringName:
	randomize()
	var ranIndex = randi_range(0,_spawner.items.size()-1)
	#print("items max range : " + str(_spawner.items.size()-1))
	#print("index : " + str(ranIndex))
	return _spawner.items[ranIndex].itemName
	
func PickRandomItem() -> SpawnableItem:
	randomize()
	var ranIndex = randi_range(0,spawnableItems.size()-1)
	#print("items max range : " + str(items.size()-1))
	#print("index : " + str(ranIndex))
	return spawnableItems[ranIndex]
	
func RemoveUniqueInstance(_instance: Node):
	if(spawned_instances.has(_instance)):
		var itemLinked: SpawnableItem = spawned_instances.get(_instance,null)
		
		spawned_instances.erase(_instance)
		print("REMOVED : " + str(_instance))
		
		
func get_spawnable_item_from_instance(instance: Node) -> SpawnableItem:
	for spawnable_item in spawned_instances.keys():
		if spawned_instances[spawnable_item] == instance:
			return spawnable_item
	return null  # pas trouvé 
	
	
func EraseItemFromSystem(itemToRemove: SpawnableItem) -> void:
	for i in range(spawnableItems.size() - 1, -1, -1):
		if spawnableItems[i].itemName == itemToRemove.itemName:
			spawnableItems.remove_at(i)
			
func StopSpawnerSystem():
	canSpawn = false
	
func StartSpawnerSystem():
	canSpawn = true
