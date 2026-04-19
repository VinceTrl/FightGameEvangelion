class_name RailArea

extends Area3D

@export var railDirection:Vector3 = Vector3.RIGHT
@export_flags_3d_physics var blockMask = 1
var parentBlock:Block

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("GetGroundBlock",Vector3(0,-0.15,0))
	#GetGroundBlock(Vector3(0,-0.15,0),Vector3(0,-0.15,0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func GetGroundBlock(targetPos:Vector3):
	#create raycast
	var queryStart: Vector3 = global_position
	var queryEnd : Vector3 = global_position + targetPos
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = blockMask
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.hit_from_inside = true
	var result = space_state.intersect_ray(query)
	
	#DebugDraw3D.draw_line(queryStart,queryEnd,Color.REBECCA_PURPLE,60)
	
	if result:
		if(result.collider.owner is Block):
			parentBlock = result.collider.owner
			parentBlock.tree_exiting.connect(DestroyRail)
			#reparent(parentBlock,true)

func SwitchRailDirection():
	railDirection = -railDirection
	pass
	
func DestroyRail():
	queue_free()
