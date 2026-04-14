extends Node3D

@export var blockScene:PackedScene = preload("uid://bja86rnp5peep")
@export var spreadTick:float = 0.5

@export var blockSize:float = 0.3

@export var excludeCollisions:CollisionObject3D
@export var raycasts:Array[RayCast3D]
@export var spreadDirections:Array[Vector3] = [Vector3.DOWN,Vector3.RIGHT,Vector3.LEFT]
@export_flags_3d_physics var castLayers = 1


@export var drawDebug:bool = false

var canUpdate:bool = true
var current


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cast in raycasts:
		cast.add_exception(excludeCollisions)
	Manager.gameManager.block_manager.BlockTicked.connect(SpreadUpdate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func SpreadUpdate():
	if(!canUpdate):return
	
	var spawnedBlock:int = 0
	
	for raycast in raycasts:
		var isEmpty := CheckEmptySpace(raycast)
		
		if(isEmpty):
			var spawnPos:Vector3 = owner.global_position + raycast.target_position
			SpawnBlock(spawnPos)
			spawnedBlock += 1
		else:
			var col = raycast.get_collider()
			print("SPREAD BLOCKED BY " + col.owner.name)
			
			
		if(spawnedBlock >= raycasts.size()):
			print("LOCK UPDATES ON " + str(owner.name))
			canUpdate = false
		
	SpreadUpdate()
	


func CheckEmptySpaceInDirection(castOrigin:Vector3,castLength:float,castDirection:Vector3) -> bool:
	#create raycast
	var queryStart: Vector3 = castOrigin
	var queryEnd : Vector3 = castOrigin + (castDirection.normalized() * castLength)
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = castLayers
	#print("MASK = " + str(queryMask))
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	#query.exclude.append(excludeCollisions.get_rid())
	var result = space_state.intersect_ray(query)
	
	if(drawDebug):
		DebugDraw3D.draw_line(queryStart,queryEnd,Color.RED,spreadTick)
	
	if result:
		print("EMPTY SPACE NOT FOUND...")
		if(drawDebug):
			DebugDraw3D.draw_sphere(result.position,0.05,Color.SKY_BLUE,spreadTick)
		return false
	else:
		print("EMPTY SPACE FOUND !")
		return true
		
		
func CheckEmptySpace(raycast:RayCast3D) -> bool:
	return !raycast.is_colliding()
	
	
func SpawnBlock(spawnPosition:Vector3):
	var scene := blockScene.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.global_position = spawnPosition
	print("Spawned New Block : " + str(scene.name))
	pass
