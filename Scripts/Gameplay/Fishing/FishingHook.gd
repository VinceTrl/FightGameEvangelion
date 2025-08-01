class_name FishHook

extends Node3D

@export var hookUpLocation: Node3D
@export var hookFishLocation: Node3D
@export var fishDistance: Vector3 = Vector3(0,-2,0.3)
@export var hookOffset:Vector3 = Vector3(0,-0.65,0)
@export var hookEaseType:Tween.EaseType = Tween.EASE_OUT
@export var hookTransType:Tween.TransitionType = Tween.TRANS_BOUNCE
@export var hookMovementTime:float = 1.75
@export var paths: Array[NodePathFollow]
@onready var hookArea: Area3D = $Area3D
@onready var path_follow_3d: NodePathFollow = $"../ItemsPositions/Path3D/PathFollow3D"


var fishingRodOwner: FishingRod
var targetPosition: Vector3 = Vector3.ZERO
var canCatchTarget = false
var targetsCaught: Array[FishHookTarget]
var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PullHook()
	pass

func SetTargetPositon(_targetPosition:Vector3):
	targetPosition = _targetPosition + hookOffset
	GoToPosition(hookMovementTime)
	
func GetFishLocation() -> Vector3:
	var location = (hookUpLocation.global_position + fishDistance)
	return location
	#return Vector3(hookUpLocation.global_position.x,y,hookUpLocation.global_position.z)

func GoToPosition(tweenTime = hookMovementTime):
	print("move hook")
	
	var initialPositon = global_position
	
	if(tween):
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self,"global_position",targetPosition,tweenTime)
	
	await tween.finished
	
	
func ThrowHook():
	SetTargetPositon(GetFishLocation())
	
func PullHook():
	canCatchTarget = true
	GetTargetsOnHook()
	SetTargetPositon(hookUpLocation.global_position)
	
func OnPullHookStop():
	canCatchTarget = false
	ReleaseAllTargets()
	
	
func GetTargetsOnHook():
	hookArea.get_overlapping_areas()
	
	for area in hookArea.get_overlapping_areas():
		if(area is FishHookTarget):
			AddFishTarget(area)
			
	pass
	
func AddFishTarget(_target:FishHookTarget):
	if(targetsCaught.has(_target)): return
	targetsCaught.append(_target)
	_target.owner.reparent(self)
	_target.CatchTarget(self)
	#add_child(_target.owner)
	
func RemoveFishTarget(_target:FishHookTarget,eraseFromArray = false):
	if(!targetsCaught.has(_target)): return
	#_target.owner.reparent(get_tree().current_scene)
	#path_follow_3d.SetChildrenNode(_target.owner,true)
	if(eraseFromArray):targetsCaught.erase(_target)
	_target.ReleaseTarget()
	
	
func AssignTargetsToPath():
	var i = 0
	for target in targetsCaught:
		paths[i].SetChildrenNode(target.owner,true)
		i += 1
		if(i >= paths.size()): i = 0
		
func MakeTargetsFollowPath():
	var p:NodePathFollow
	for path in paths:
		path.StartFollowPath()
		p = path
	await p.OnEndFollowPath
	
func ReleaseAllTargets():
	AssignTargetsToPath()
	await MakeTargetsFollowPath()
	
	for target in targetsCaught:
		if(target != null):
			RemoveFishTarget(target)
		
	targetsCaught.clear()
	#path_follow_3d.StartFollowPath()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#global_position = hookUpLocation.global_position + hookOffset
	pass

func _on_area_entered(area: Area3D) -> void:
	if(!canCatchTarget): return
	
	if(area is FishHookTarget):
		AddFishTarget(area)
