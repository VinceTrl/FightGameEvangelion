class_name Spawner
extends Node3D

@export var items: Array[SpawnableItem] = []
@export var registerOnManager = true
@onready var ground_raycast: RayCast3D = $GroundRaycast

const VFX_2D_SPAWN_SMOKE = preload("res://Scenes/VFX/VFX2D/vfx_2d_spawn_smoke.tscn")

func _ready() -> void:
	PreloadResources()
	
	if(registerOnManager):
		Manager.spawnManager.RegisterSpawner(self)
		if(ground_raycast == null):
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
	
	if(_item.spawnOnGround and ground_raycast.is_colliding()):
		_spawnPos = ground_raycast.get_collision_point()
		_spawnPos = _spawnPos + _item.groundOffset
		
	
	var _itemInstance = _item.resource.instantiate()
	if(_itemInstance == null) : return
	
	add_child(_itemInstance)
	_itemInstance.global_position = _spawnPos
	
func SpawnExternalItem(_itemToSpawn: SpawnableItem):
	
	if(_itemToSpawn == null): return
	
	var _spawnPos = global_position
	
	if(_itemToSpawn.spawnOnGround and ground_raycast.get_collider() != null):
		_spawnPos = ground_raycast.get_collision_point()
		_spawnPos = _spawnPos + _itemToSpawn.groundOffset
		
		
	var vfx = VFX_2D_SPAWN_SMOKE.instantiate()
	vfx.global_position = _spawnPos
	get_tree().current_scene.add_child(vfx)
		
	
	var _itemInstance = _itemToSpawn.resource.instantiate()
	if(_itemInstance == null) : return
	
	add_child(_itemInstance)
	_itemInstance.global_position = _spawnPos
	
	
func GetItemFromName(_name: StringName) -> SpawnableItem:
	
	for item in items: 	
		if(item.itemName == _name): return item
	
	push_error("No item found")
	return null
