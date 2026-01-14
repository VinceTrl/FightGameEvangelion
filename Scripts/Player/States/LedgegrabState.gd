extends PlayerState

@export var ledgeGrabDuration = 0.2
@export var offset:Vector3 = Vector3(0,0.2,0)
@export var snapToPositionX:Curve
@export var snapToPositionY:Curve

var ledgegrabPosition
var targetPosition
var canLedge = false

const rayOffsetX = 0.3
const rayLenght = 1

func EnterState():
	Name = "Ledgegrab"
	Player.velocity = Vector3.ZERO
	
	var raycast: RayCast3D
	
	#create raycast
	var queryStart: Vector3
	var queryEnd : Vector3
	
	if(Player.ledge_right_lower_cast.is_colliding()):
		print("RIGHT LEDGE")
		Player.ledgeDirection = Vector3(1,0,0)
		raycast = Player.ledge_right_lower_cast
		
		queryStart = Player.ledge_right_upper_cast.global_position
		queryStart.x += rayOffsetX
		
	else:
		print("LEFT LEDGE")
		Player.ledgeDirection = Vector3(-1,0,0)
		raycast = Player.ledge_left_lower_cast
		
		queryStart = Player.ledge_left_upper_cast.global_position
		queryStart.x += -rayOffsetX
	
	var startPos = raycast.get_collision_point()
	var endPos
	queryEnd = Vector3(queryStart.x,queryStart.y - rayLenght,queryStart.z)
	var space_state = Player.get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var queryMask = mask_from_layers([Player.collisionLayer])
	print("MASK = " + str(queryMask))
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	var result = space_state.intersect_ray(query)
	
	
	if result and result.collider.is_in_group("Ledgegrab"):
		endPos = result.position + offset
		canLedge = true
		print("RESULT : "  + str(result))
		ledgegrabPosition = Player.global_position
		targetPosition = endPos
		Player.animator.play("Ledgegrab")
	else:
		Player.ChangeState(Player.States.Fall)
	
func mask_from_layers(layers: Array[int]) -> int:
	var mask := 0
	for layer in layers:
		mask |= 1 << (layer - 1) # Active corresponding bit 
	return mask

func ExitState():
	canLedge = false

func Draw():
	pass
	
func Update(delta: float):
	HandleAutoLedgeGrab()

func HandleAnimations():
	pass
	
func HandleAutoLedgeGrab():
	if(!canLedge): return
	SnapPosition()
	
func SnapPosition():
	if(!canLedge): return
	
	var timer = get_tree().create_timer(ledgeGrabDuration,true,false,false)
	
	while timer.time_left > 0.0:
		var _timeProgress = ledgeGrabDuration - timer.time_left 
		var _ratio = _timeProgress/ledgeGrabDuration
		var _transCurveValueX = snapToPositionX.sample(_ratio)
		var _transCurveValueY = snapToPositionY.sample(_ratio)
		
		var targetX = lerp(ledgegrabPosition.x,targetPosition.x,_transCurveValueX)
		var targetY = lerp(ledgegrabPosition.y,targetPosition.y,_transCurveValueY)
		var targetZ = lerp(ledgegrabPosition.z,targetPosition.z,_transCurveValueX)
		
		print("LEDGE GRAB SNAPPING")
		Player.global_position = Vector3(targetX,targetY,targetZ)
		
		await get_tree().process_frame
	
	OnLedgeGrabEnd()
	
func OnLedgeGrabEnd():
	canLedge = false
	Player.ChangeState(States.Idle)
