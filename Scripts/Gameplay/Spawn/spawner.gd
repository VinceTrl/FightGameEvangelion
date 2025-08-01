class_name Spawner
extends Node3D

@export var items: Array[SpawnableItem] = []
@export var registerOnManager = true
@export var canSpawnOnPlayer = false
@export var forceSpawnOnGround = false

@export_group("Curved spawn")
@export var minControlCurve: float = 0.5
@export var maxControlCurve: float = 1.25
@export var verticalControlMultiplier = 1.25
@export var groundOffset:Vector3 = Vector3(0.25,0,0)
@export_group("")

@onready var ground_raycast: RayCast3D = $GroundRaycast
@onready var player_raycast: RayCast3D = $PlayerRaycast
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var path_3d: Path3D = $Path3D
@onready var node_path_follow: NodePathFollow = $Path3D/NodePathFollow

const VFX_2D_SPAWN_SMOKE = preload("res://Scenes/VFX/VFX2D/vfx_2d_spawn_smoke.tscn")
const SPAWN_TRAIL = preload("res://Scenes/VFX/spawn_trail.tscn")

func _ready() -> void:
	PreloadResources()
	
	if(registerOnManager):
		Manager.spawnManager.RegisterSpawner(self)
		if(ground_raycast == null):
			push_error("NULL RAYCAST")
			
	#await get_tree().create_timer(3).timeout
	#SetUpPath(global_position,ground_raycast.get_collision_point())
	
func _process(delta: float) -> void:
	#DebugSpawner()
	pass

func DebugSpawner() -> void:
	
	if(Input.is_action_just_pressed("DebugKey")):
		#SpawnItem("MIDDLE_FINGER")
		if player_raycast.is_colliding():
			var collider = player_raycast.get_collider()
			print("RAYCAST PLAYER : " + str(player_raycast.get_collider().collision_layer))
	
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
		
	if(forceSpawnOnGround):
		_spawnPos = ground_raycast.get_collision_point() + groundOffset
		_spawnPos = _spawnPos + _itemToSpawn.groundOffset
		#await SpawnTrail(global_position,_spawnPos)
		await SpawnOnPath(global_position,_spawnPos)
		
		
	var vfx = VFX_2D_SPAWN_SMOKE.instantiate()
	vfx.global_position = _spawnPos
	get_tree().current_scene.add_child(vfx)
	
	audio.global_position = _spawnPos
	audio.play()
	
	var _itemInstance = _itemToSpawn.resource.instantiate()
	if(_itemInstance == null) : return
	
	get_tree().current_scene.add_child(_itemInstance)
	_itemInstance.global_position = _spawnPos
	return _itemInstance
	
	
func GetItemFromName(_name: StringName) -> SpawnableItem:
	
	for item in items: 	
		if(item.itemName == _name): return item
	
	push_error("No item found")
	return null
	
func IsPlayerUnderSpawner() -> bool:
	var col = player_raycast.get_collider()
	
	if(col != null):
		return true
	else:
		return false
	#return player_raycast.is_colliding()
	
func SpawnTrail(startPos:Vector3,targetPos:Vector3):
	var trail = SPAWN_TRAIL.instantiate()
	trail.global_position = startPos
	get_tree().current_scene.add_child(trail)
	trail.MoveTrail(targetPos)
	await trail.OnTrailReachDestination
	trail.queue_free()
	
	

	
func SetUpPath(startPos:Vector3,targetPos:Vector3):
	var dist = startPos.distance_to(targetPos)
	var maxDistanceToCheck = abs(ground_raycast.target_position.y)
	var ratio = dist / maxDistanceToCheck
	var dif = targetPos - startPos
	var control = lerp(minControlCurve,maxControlCurve,ratio)
	var vControl = control * verticalControlMultiplier
	
	var positive: bool = randi_range(0,1)
	if(!positive): control = -control
	
	var controlVectorStart = Vector3(control,vControl,0)
	var controlVectorEnd = Vector3(control,0,0)
	
	var curve:Curve3D = Curve3D.new()
	curve.add_point(Vector3.ZERO,Vector3.ZERO,controlVectorStart)
	curve.add_point(dif,controlVectorEnd,Vector3.ZERO)
	path_3d.curve = curve
	
	
func SpawnOnPath(startPos:Vector3,targetPos:Vector3):
	SetUpPath(startPos,targetPos)
	var trail = SPAWN_TRAIL.instantiate()
	trail.global_position = startPos
	get_tree().current_scene.add_child(trail)
	print("SPAWNED TRAIL : " + str(trail))
	node_path_follow.SetChildrenNode(trail,true)
	node_path_follow.StartFollowPath()
	await node_path_follow.OnEndFollowPath
	print("FREE TRAIL : " + str(trail))
	trail.queue_free()
