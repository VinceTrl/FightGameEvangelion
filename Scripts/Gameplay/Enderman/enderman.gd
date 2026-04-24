extends Character

@export var teleportDelay:float = 0.5

@export_group("enderman components")
@export var holdSocket:Node3D
@export var targetRaycast:RayCast3D
@export var raycasts:Array[RayCast3D]

const VFX_2D_PORTAL = preload("uid://pbkef8ngst4f")


var chaseTarget:Node3D

var isHoldingItem:bool = false
var holdItem:Node3D
var holdItemCollision:CollisionObject3D

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
	flip.ProcessFlip()
	ProcessHoldItem()
	
	if(!holdItem):return
	
	
	var drawDebugOffset:Vector3 = Vector3(0.0,1.5,0.1)
	var textColor:Color = Color.NAVY_BLUE
	#DebugDraw3D.draw_text(global_position+drawDebugOffset,holdItem.name,32,textColor)


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
	
	#DebugDraw3D.draw_line(queryStart,queryEnd,Color.REBECCA_PURPLE,6)
	
	if result:
		return result.position
	else:
		return safeLocation
		
func TakeDamage(hitbox:Hitbox):
	if(currentState != stateMachine.Hurt and currentState != stateMachine.Death):
		lastHitbox = hitbox
		ChangeState(stateMachine.Hurt)
		
#region Teleport functions

#set next teleport to the safe location
func SetTeleportToSafeLocation():
	nextTeleportPosition = GetSafeLocation()
	pass


func Teleport(targetPosition:Vector3):
	SpawnPortalVFX(global_position)
	await get_tree().create_timer(teleportDelay).timeout
	SpawnPortalVFX(targetPosition)
	global_position = targetPosition
	pass
	
func SpawnPortalVFX(pos:Vector3):
	var portal := VFX_2D_PORTAL.instantiate()
	get_tree().current_scene.add_child(portal)
	portal.global_position = pos
	pass
	
#endregion

#region Item Handle functions

func StealTarget(target:Node3D,targetCol:CollisionObject3D):
	target.global_position = holdSocket.global_position
	target.reparent(holdSocket)
	isHoldingItem = true
	holdItem = target
	
	if(targetCol):
		holdItemCollision = targetCol
		for cast in raycasts:
			cast.add_exception(holdItemCollision)
	
func ProcessHoldItem():
	if(isHoldingItem):return
	if(!holdItem):return
	
	holdItem.global_position = holdSocket.global_position
	
func DropItem():
	if(!isHoldingItem):return
	
	if(!holdItem):
		isHoldingItem = false
		holdItem = null
		holdItemCollision = null
		for cast in raycasts:
			cast.clear_exceptions()
		return
		
	
	holdItem.reparent(get_tree().current_scene)
	
	if(holdItem is PlayerCharacter):
		holdItem.scale = Vector3.ONE
		holdItem.global_position.z = 0.0
		holdItem.global_rotation = Vector3.ZERO
		holdItem.ChangeState(holdItem.States.Fall)
	else:
		holdItem.global_position = GetGroundLocation()
		
	isHoldingItem = false
	holdItem = null
	holdItemCollision = null
	
	for cast in raycasts:
		cast.clear_exceptions()
	
#endregion
	
func GetGroundLocation() -> Vector3:
	#create raycast
	var queryStart: Vector3 = targetRaycast.global_position
	var queryEnd : Vector3 = (targetRaycast.global_position + targetRaycast.target_position) + (Vector3.DOWN * 30)
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = 1
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.hit_from_inside = true
	#if(holdItem):
		#query.exclude.append(holdItem.rid)
	var result = space_state.intersect_ray(query)
	
	#DebugDraw3D.draw_line(queryStart,queryEnd,Color.ROSY_BROWN,6)
	
	if result:
		return result.position
	else:
		return holdSocket.global_position
