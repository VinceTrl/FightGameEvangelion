extends Node3D

@export var hidePosition: Vector3
@export var targetOffset: Vector3
@export var followLerp: float = 0.05
var rotationMode: bool = false
var nodeToFollow: Node3D
var isFollowing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#call_deferred("DebugFollow")
	call_deferred("ConnectSignals")
	
func ConnectSignals():
	Manager.gameManager.eva.OnSlapStart.connect(OnSlapStart)
	Manager.gameManager.eva.OnSlapHitStart.connect(StopFollow)
	print("HAND : CONNECTED TO SIGNALS")
	
func DebugFollow():
	SetNodeToFollow(Manager.gameManager.players[0])
	
	
func OnSlapStart():
	StartFollow(Manager.gameManager.eva.target)
	
	
func StartFollow(target:Node3D):
	SetNodeToFollow(target)
	isFollowing = true
	print("HAND : START FOLLOW")
	
func StopFollow():
	isFollowing = false
	nodeToFollow = null
	print("HAND : STOP FOLLOW")

func SetNodeToFollow(target:Node3D):
	nodeToFollow = target
	
func MoveToTarget():
	var targetPos: Vector3 = hidePosition
	
	if(nodeToFollow and isFollowing):
		targetPos = Vector3(nodeToFollow.global_position.x,nodeToFollow.global_position.y,nodeToFollow.global_position.z)
		targetPos = targetPos + targetOffset
		print("HAND : is following target")
	
	#print("HAND : follow on pos : ",targetPos)
	global_position = lerp(global_position,targetPos,followLerp)
	
	
func RotateToTarget(target:Node3D,delta:float):
	#cache the current rotation
	#var rot = Quaternion(rotation)
	## use look_at to look at the desired location
	#look_at(target_pos, Vector3.UP)
	## cache the new "target" rotation
	#var target_rot = Quat(rotation)
	##use Quat.Slerp to perform spherical interpolation to the target rotation
	##a weight like 0.1 works well
	##then set the rotation by converting the Quat back to a Eule
	#rotation = rotation.slerp(target_rot, weight).get_euler()
	
	if(!rotationMode): return
	if(!target): return
	
	look_at(target.global_position)
	var targetRot = Quaternion(target.global_transform.basis)
	var currentRot = Quaternion(global_transform.basis)
	var nextRot = currentRot.slerp(targetRot,delta * 3)
	global_transform.basis = Basis(nextRot)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	MoveToTarget()
