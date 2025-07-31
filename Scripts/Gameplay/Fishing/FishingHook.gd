class_name FishHook

extends Node3D

@export var hookUpLocation: Node3D
@export var hookFishLocation: Node3D
@export var hookOffset:Vector3
@export var hookEaseType:Tween.EaseType = Tween.EASE_OUT
@export var hookTransType:Tween.TransitionType = Tween.TRANS_BOUNCE
@export var hookMovementTime = 0.25

var targetPosition: Vector3 = Vector3.ZERO
var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PullHook()
	pass

func SetTargetPositon(_targetPosition:Vector3):
	targetPosition = _targetPosition + hookOffset
	GoToPosition(hookMovementTime)

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
	SetTargetPositon(hookFishLocation.global_position)
	
func PullHook():
	SetTargetPositon(hookUpLocation.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#global_position = hookUpLocation.global_position + hookOffset
	pass
