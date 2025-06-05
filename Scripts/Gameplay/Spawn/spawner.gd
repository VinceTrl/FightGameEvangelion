class_name Spawner
extends Node3D

@export var items: Array[SpawnableItem] = []
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
	PreloadResources()
	Manager.spawnManager.RegisterSpawner(self)
	if(ray_cast_3d == null):
		push_error("NULL RAYCAST")
	
func _process(delta: float) -> void:
	#DebugSpawner()
	pass

func DebugSpawner() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		SpawnItem("MIDDLE_FINGER")
	
func PreloadResources():
	for item in items: 	
		item.resource = load(str(item.scenePath))


func SpawnItem(_itemToSpawn: StringName = "EXPLOSION"):
	
	var _item = GetItemFromName(_itemToSpawn)
	if(_item == null): return
	
	var _spawnPos = global_position
	
	if(_item.spawnOnGround and ray_cast_3d.is_colliding()):
		_spawnPos = ray_cast_3d.get_collision_point()
		_spawnPos = _spawnPos + _item.groundOffset
		
	
	var _itemInstance = _item.resource.instantiate()
	if(_itemInstance == null) : return
	
	add_child(_itemInstance)
	_itemInstance.global_position = _spawnPos
	
func SpawnExternalItem(_itemToSpawn: SpawnableItem):
	
	if(_itemToSpawn == null): return
	
	var _spawnPos = global_position
	
	if(_itemToSpawn.spawnOnGround and ray_cast_3d.get_collider() != null):
		_spawnPos = ray_cast_3d.get_collision_point()
		_spawnPos = _spawnPos + _itemToSpawn.groundOffset
		
	
	var _itemInstance = _itemToSpawn.resource.instantiate()
	if(_itemInstance == null) : return
	
	add_child(_itemInstance)
	_itemInstance.global_position = _spawnPos
	
	
func GetItemFromName(_name: StringName) -> SpawnableItem:
	
	for item in items: 	
		if(item.itemName == _name): return item
	
	push_error("No item found")
	return null
