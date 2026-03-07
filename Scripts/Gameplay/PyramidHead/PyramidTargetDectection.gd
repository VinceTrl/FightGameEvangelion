class_name PyramidHeadTargetDetection

extends ShapeCast3D

@export var alwaysProcessDetection:bool = false
@export var drawDebugCast:bool = false
@export var obstacleDetectionOrigin:Node3D

var targetInCast:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugCast()
	if(alwaysProcessDetection):
		ProcessDetection()

func EnableDetection(enable:bool):
	enabled = enable

func ProcessDetection():
	if(is_colliding()):
		var targetDetected:bool = false
		for collision in get_collision_count():
			if(get_collider(collision).is_in_group("PyramidHeadTarget")):
				if(!CheckObstacle(get_collision_point(collision))):
					targetDetected = true
		if(!targetInCast and targetDetected):
			targetInCast = true
		elif(targetInCast and targetDetected):
			return
		else:
			targetInCast = false
	else:
		targetInCast = false
		
func DebugCast():
	if(!drawDebugCast):return
	if(is_colliding()):
		for collision in get_collision_count():
			var position := get_collision_point(collision)
			DebugDraw3D.draw_sphere(position,0.1,Color.GREEN)
			#DebugDraw3D.draw_square(position,0.2,Color.CRIMSON)
			
			
func CheckObstacle(targetPos:Vector3) -> bool:
	#create raycast
	var queryStart: Vector3 = obstacleDetectionOrigin.global_position
	var queryEnd : Vector3 = targetPos
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = mask_from_layers([1])
	print("MASK = " + str(queryMask))
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	var result = space_state.intersect_ray(query)
	
	if(drawDebugCast):
		DebugDraw3D.draw_line(queryStart,queryEnd,Color.RED,2)
	
	if result:
		print("RESULT : "  + str(result))
		if(result.collider.is_in_group("PyramidHeadTarget")):
			return false
		if(drawDebugCast):
			DebugDraw3D.draw_sphere(result.position,0.1,Color.RED,2)
		
		return true
	else:
		print("NO RESULT")
		return false

func mask_from_layers(layers: Array[int]) -> int:
	var mask := 0
	for layer in layers:
		mask |= 1 << (layer - 1) # Active corresponding bit layer
	return mask
