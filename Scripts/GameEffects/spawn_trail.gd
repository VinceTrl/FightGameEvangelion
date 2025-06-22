extends Node3D


@export var moveSpeed:float = 3
@export var moveEaseType:Tween.EaseType = Tween.EASE_IN_OUT
@export var moveTransType:Tween.TransitionType = Tween.TRANS_LINEAR
@export var offsetX:float = 3.0
@export var animationCurve:Curve
@export var offsetCurveX:Curve

var targetLocation

signal OnTrailStartMoving
signal OnTrailReachDestination


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func MoveTrailVFX(targetPosition: Vector3):

	var tween = get_tree().create_tween()
	tween.set_ease(moveEaseType)
	tween.set_trans(moveTransType)
	tween.set_parallel(true)
	
	var time = GetTweenTime(targetPosition)
	
	tween.tween_property(self,"global_position:x",targetPosition.x,time)
	tween.tween_property(self,"global_position:y",targetPosition.y,time)
	tween.tween_property(self,"global_position:z",targetPosition.z,time)
		
	OnTrailStartMoving.emit()
	await tween.finished
	OnTrailReachDestination.emit()
	
func GetTweenTime(targetPosition:Vector3) -> float:
	var distance = position.distance_to(targetPosition)
	return distance / moveSpeed
	
func MoveTrail(targetPosition: Vector3):
	var _initPos = global_position
	var _targetPos = targetPosition
	var time = GetTweenTime(_targetPos)
	var timer = get_tree().create_timer(time,true,false,false)
	
	var positiveOffset: bool = randi_range(0,1)
	
	OnTrailStartMoving.emit()
	while timer.time_left > 0.0:
		var _timeProgress = time - timer.time_left 
		var _ratio = _timeProgress/time
		var _animCurveValue = animationCurve.sample(_ratio)
		var _offsetCurveValueX = offsetCurveX.sample(_ratio)
		
		var _targetX = lerp(_initPos.x,_targetPos.x,_animCurveValue)
		var _targetY = lerp(_initPos.y,_targetPos.y,_animCurveValue)
		var _targetZ = lerp(_initPos.z,_targetPos.z,_animCurveValue)
		var _offsetX = lerp(0.0,offsetX,_offsetCurveValueX)
		
		var _resultX
		if(positiveOffset):
			_resultX = _targetX+_offsetX
		else:
			_resultX = _targetX-offsetX
		
		global_position = Vector3(_resultX,_targetY,_targetZ)
		
		if !is_instance_valid(get_tree()):
			return
		
		await get_tree().process_frame

	#reset
	OnTrailReachDestination.emit()
