extends Node

@export var root:Node3D
@export var castDirection:Vector3 = Vector3.DOWN
@export var castLength:float = 0.15
@export_flags_3d_physics var blockMask = 1

var parentBlock:Block

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!root and owner): 
		root = owner
	call_deferred("GetGroundBlock")

func GetGroundBlock():
	#create raycast
	var queryStart: Vector3 = root.global_position
	var queryEnd : Vector3 = root.global_position + (castDirection * castLength)
	
	var space_state = root.get_world_3d().direct_space_state
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
			#parentBlock.tree_exiting.connect(DestroyRail)
			reparent(parentBlock.node_shaker,true)
