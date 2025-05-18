extends Node3D


@export_group("Position animation")
@export var animPosition = true
@export var positionTime = 1.0
@export var positionTarget: Vector3 = Vector3.ONE
@export var positionCurveX : Curve
@export var positionCurveY : Curve
@export var positionCurveZ : Curve

@export_group("Rotation animation")
@export var animRotation = false
@export var rotationTime = 1.0
@export var rotationTarget: Vector3 = Vector3.ONE
@export var rotationCurveX : Curve
@export var rotationCurveY : Curve
@export var rotationCurveZ : Curve

var initPosition
var initRotation
var targetPos
var targetRot

var isAnimatingPosition = false
var isAnimatingRotation = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initPosition = global_position
	initRotation = global_rotation
	targetPos = initPosition + positionTarget
	targetRot = initRotation + rotationTarget
	Manager.gameManager.FightEnd.connect(StopAnimation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AnimPosition()
	
	
func AnimPosition():
	if(!animPosition): return
	if(isAnimatingPosition): return
	
	isAnimatingPosition = true
	
	var posTimer = get_tree().create_timer(positionTime,true,false,false)
	
	while posTimer.time_left > 0.0:
		
		var _timeProgress = positionTime - posTimer.time_left 
		var _ratio = _timeProgress/positionTime
		var _curveValueX = positionCurveX.sample(_ratio)
		var _curveValueY = positionCurveY.sample(_ratio)
		var _curveValueZ = positionCurveZ.sample(_ratio)
		
		var _currentPosX = lerp(initPosition.x,targetPos.x,_curveValueX)
		var _currentPosY = lerp(initPosition.y,targetPos.y,_curveValueY)
		var _currentPosZ = lerp(initPosition.z,targetPos.z,_curveValueZ)
		
		var _currentPos = Vector3(_currentPosX,_currentPosY,_currentPosZ)
	
		global_position = _currentPos
		
		await get_tree().process_frame
	
	isAnimatingPosition = false
	global_position = initPosition
	
func AnimRotation():
	pass
	
func StopAnimation():
	isAnimatingPosition = false
	isAnimatingRotation = false
	animPosition = false
	animRotation = false
