extends Node3D

@export var items: Array[SpawnableItem] = []

func _ready() -> void:
	PreloadResources()
	
func _process(delta: float) -> void:
	DebugSpawner()

func DebugSpawner() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		SpawnItem("FALLING PROJECTILE")
	
func PreloadResources():
	for item in items: 	
		item.resource = load(str(item.scenePath))


func SpawnItem(_itemToSpawn: StringName = "EXPLOSION",_spawnOnGround: bool = false):
	
	var _item = GetItemFromName(_itemToSpawn)
	if(_item == null): return
	
	var _spawnPos = global_position
	
	var _itemInstance = _item.resource.instantiate()
	if(_itemInstance == null) : return
	
	add_child(_itemInstance)
	_itemInstance.global_position = _spawnPos
	
	
func GetItemFromName(_name: StringName) -> SpawnableItem:
	
	for item in items: 	
		if(item.itemName == _name): return item
	
	push_error("No item found")
	return null
