extends Node3D

@export var blockScene:PackedScene = preload("uid://bja86rnp5peep")
@export var spreadTick:float = 0.5

@export var blockSize:float = 0.3

@export var excludeCollisions:CollisionObject3D
@export var spreadDirections:Array[Vector3] = [Vector3.DOWN,Vector3.RIGHT,Vector3.LEFT]
@export_flags_3d_physics var castLayers = 1


@export var drawDebug:bool = false

var canUpdate:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpreadUpdate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func SpreadUpdate():
	if(!canUpdate):return
	
	#await get_tree().create_timer(spreadTick).timeout
	var spawnedBlock:int = 0
	
	for direction in spreadDirections:
		var isEmpty := CheckEmptySpaceInDirection(global_position,blockSize,direction)
		
		if(isEmpty):
			var spawnPos:Vector3 = owner.global_position + (direction.normalized() * blockSize)
			SpawnBlock(spawnPos)
			spawnedBlock += 1
			
		await get_tree().create_timer(spreadTick).timeout
		
		if(spawnedBlock >= spreadDirections.size()): canUpdate = false
		
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
		
		
func SpawnBlock(spawnPosition:Vector3):
	var scene := blockScene.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.global_position = spawnPosition
	print("Spawned New Block")
	pass
