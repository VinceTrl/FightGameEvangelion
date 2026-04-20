extends Character

@export_group("enderman components")
@export var health:HealthComponent
@export var holdSocket:Node3D
@export var targetRaycast:RayCast3D

var isHoldingItem:bool = false
var holdItem:Node3D

var safeLocation:Vector3
var safeLocationCastHeight:float = 10
var safeLocationAmplitude:float = 3

var lastHitbox:Hitbox

var nextTeleportPosition:Vector3 = Vector3.ZERO

func _ready() -> void:
	super()
	#var material := creeperMesh.get_active_material(0).duplicate()
	#creeperMesh.set_surface_override_material(0,material)
	previousState = stateMachine.Idle
	currentState = stateMachine.Idle
	stateMachine.currentState = currentState
	ChangeState(stateMachine.Idle)
	
func _process(delta: float) -> void:
	super(delta)
	if(!holdItem):return
	
	holdItem.global_position = holdSocket.global_position
	var drawDebugOffset:Vector3 = Vector3(0.0,1.5,0.1)
	var textColor:Color = Color.NAVY_BLUE
	DebugDraw3D.draw_text(global_position+drawDebugOffset,holdItem.name,32,textColor)

func SetSafeLocation():
	var x = randf_range(-safeLocationAmplitude,safeLocationAmplitude)
	var y = safeLocationCastHeight
	safeLocation = Vector3(x,y,0.0)
	
func GetSafeLocation() -> Vector3:
	#create raycast
	var queryStart: Vector3 = safeLocation
	var queryEnd : Vector3 = safeLocation + (Vector3.DOWN * safeLocationCastHeight)
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = 1
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.hit_from_inside = true
	var result = space_state.intersect_ray(query)
	
	DebugDraw3D.draw_line(queryStart,queryEnd,Color.REBECCA_PURPLE,60)
	
	if result:
		return result.position
	else:
		return safeLocation
		
func TakeDamage(hitbox:Hitbox):
	if(currentState != stateMachine.Hurt):
		lastHitbox = hitbox
		ChangeState(stateMachine.Hurt)
		
#set next teleport to the safe location
func SetTeleportToSafeLocation():
	nextTeleportPosition = GetSafeLocation()
	pass
	
func Teleport():
	global_position = nextTeleportPosition
	pass
	
func StealTarget(target:Node3D):
	target.global_position = holdSocket.global_position
	#target.reparent(holdSocket)
	isHoldingItem = true
	holdItem = target
	
func DropItem():
	if(!isHoldingItem):return
	if(!holdItem):return
	#holdItem.reparent(get_tree().current_scene)
	holdItem.global_position = GetGroundLocation()
	
	isHoldingItem = false
	holdItem = null
	pass
	
func GetGroundLocation() -> Vector3:
	#create raycast
	var queryStart: Vector3 = targetRaycast.global_position
	var queryEnd : Vector3 = targetRaycast.global_position + targetRaycast.target_position
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = 1
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.hit_from_inside = true
	#if(holdItem):
		#query.exclude.append(holdItem.rid)
	var result = space_state.intersect_ray(query)
	
	DebugDraw3D.draw_line(queryStart,queryEnd,Color.ROSY_BROWN,60)
	
	if result:
		return result.position
	else:
		return holdSocket.global_position
