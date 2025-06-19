class_name GameCamera

extends Node3D

@export var player1: Node3D
@export var player2: Node3D
@export var cameraTargets: Array[Node3D] = []

@export var minDistZ = 2.0
@export var maxDistZ = 4.5
@export var minPlayerDist = 3.5
@export var maxPlayerDist = 8
@export var zDistCurve: Curve

@export var cameraOffset: Vector3 = Vector3.ZERO

@export var cameraSmoothnessX = 2.0
@export var cameraSmoothnessY = 1.0
@export var cameraSmoothnessZ = 0.25

#camera clamp
@export var canClampPosition: bool = true
@export var cameraClampMax: Vector2 = Vector2(5.5,1.0)
@export var cameraClampMin: Vector2 = Vector2(-0.5,-1.0)

@export var defaultZoom: ZoomParameters

@export var zoomParams: Array[ZoomParameters] = []

@onready var camShake: CameraShake = $CameraShake
@onready var camera: Camera3D = $CameraShake/Camera3D

@export var debugMode = false
@onready var center_debug_label: Label3D = $CENTER_DEBUG_LABEL
@onready var debug_values: Label = $DEBUG_VALUES
@onready var cam_center: Sprite3D = $Cam_Center

var followPlayers: bool = true
var usePlayerDistanceForTargetZ = true

var updateZposition = true
var updateXYposition = true
var inZoomMode = false

#TWEEN VARIABLES
var TweenCamXY
var TweenCamZ

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameCamera = self
	
	if(debugMode): 
		center_debug_label.visible = true
		debug_values.visible = true
		cam_center.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdatePositon_XY()
	UpdatePositon_Z()
	ClampCameraPosition()
	#debugCamera()
	
func debugCamera() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		#SimpleCameraShake()
		#AdvancedCameraShake()
		#CameraZoom(player1)
		FocusTargetZoom(player1,GetZoomParamFromName("MidFocusZoom"))
	
func UpdatePositon_XY():
	if(!updateXYposition): return
	
	#print("update XY")
	#var _middlePos: Vector3 = player1.global_position + player2.global_position/2
	var _middlePos: Vector3 = 0.5 * (player1.global_position + player2.global_position)
	_middlePos = GetAveragePosition(cameraTargets)
	var _newPos: Vector3 = Vector3(_middlePos.x,_middlePos.y,global_position.z) + cameraOffset
	#global_position = _newPos
	
	#tween
	if TweenCamXY:
		TweenCamXY.kill()
		
	TweenCamXY = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	TweenCamXY.tween_property(self,"position:x",_newPos.x,cameraSmoothnessX)
	TweenCamXY.tween_property(self,"position:y",_newPos.y,cameraSmoothnessY)
	
	if(debugMode): center_debug_label.global_position = Vector3(_newPos.x,_newPos.y,0)
	
func UpdatePositon_Z():
	if(!updateZposition): return
	
	#print("update Z")
	var _currentZ = maxDistZ
	
	if(usePlayerDistanceForTargetZ):
		_currentZ = GetZtargetPosition()
	
	if TweenCamZ:
		TweenCamZ.kill()
		
	TweenCamZ = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	TweenCamZ.tween_property(self,"position:z",_currentZ,cameraSmoothnessZ)
	
	
func ClampCameraPosition():
	if(!canClampPosition): return
	
	#print("update Z")
	var _clampPosMin = Vector3(cameraClampMin.x,cameraClampMin.y,global_position.z)
	var _clampPosMax = Vector3(cameraClampMax.x,cameraClampMax.y,global_position.z)
	
	global_position = global_position.clamp(_clampPosMin,_clampPosMax)

func GetZtargetPosition() -> float:
	var _currentDistPlayers: float = player1.global_position.distance_to(player2.global_position)
	var _playersDistRatio = _currentDistPlayers / maxPlayerDist
	var _curveValue = zDistCurve.sample(_playersDistRatio);
	var _zPos = lerp(minDistZ,maxDistZ,_curveValue)
	
	if(debugMode): 
		var debug_dist = "\n /player dist : " + str(_currentDistPlayers)
		var debug_zCam = "\n /cam z dist : " + str(_zPos)
		var debug_distRatio = "\n /player ratio dist : " + str(_playersDistRatio)
		var debug_posX = "\n /Cam X : " + str(global_position.x)
		var debug_posY = "\n /Cam Y : " + str(global_position.y)
		debug_values.text = "DEBUG : " + debug_dist + debug_distRatio + debug_zCam + debug_posX + debug_posY
	
	return _zPos
	
#zoom that ignores zoom distance
func FocusTargetZoom(_target: Node3D,_zoomParams: ZoomParameters = defaultZoom):
	ZoomOnTarget(_target,GetZtargetPosition(),_zoomParams.zoomDuration,_zoomParams.zoomCurve,_zoomParams.translationCurve,true,true)
	
func CameraZoom(_target: Node3D,_zoomParams: ZoomParameters = defaultZoom):
	if(_target == null): return
	ZoomOnTarget(_target,_zoomParams.zoomDistance,_zoomParams.zoomDuration,_zoomParams.zoomCurve,_zoomParams.translationCurve)

func ZoomOnTarget(_targetNode: Node3D,_zoomDistance: float = defaultZoom.zoomDistance,_zoomDuration: float = defaultZoom.zoomDuration,_zoomCurve: Curve = defaultZoom.zoomCurve,_transCurve: Curve = defaultZoom.translationCurve,_keepCamUpdateXY: bool = false,_keepCamUpdateZ: bool = false):
	if(_targetNode == null): return
	
	updateXYposition = _keepCamUpdateXY
	updateZposition = _keepCamUpdateZ
	
	if TweenCamZ and !_keepCamUpdateZ:
		TweenCamZ.kill()
		
	if TweenCamXY and !_keepCamUpdateXY:
		TweenCamXY.kill()
		
	inZoomMode = true
	
	var _initPos = global_position
	var _targetPos = _targetNode.global_position
	var zoomTimer = get_tree().create_timer(_zoomDuration,true,false,false)
	
	while zoomTimer.time_left > 0.0:
		var _timeProgress = _zoomDuration - zoomTimer.time_left 
		var _ratio = _timeProgress/_zoomDuration
		var _zoomCurveValue = _zoomCurve.sample(_ratio)
		var _transCurveValue = _transCurve.sample(_ratio)
		
		var _zoomTargetX = lerp(_initPos.x,_targetPos.x,_transCurveValue)
		var _zoomTargetY = lerp(_initPos.y,_targetPos.y,_transCurveValue)
		var _zoomTargetZ = lerp(_initPos.z,_zoomDistance,_zoomCurveValue)
		
		global_position = Vector3(_zoomTargetX,_zoomTargetY,_zoomTargetZ)
		
		if !is_instance_valid(get_tree()):
			return
		
		await get_tree().process_frame

	#reset
	updateXYposition = true
	updateZposition = true
	inZoomMode = false
	
func GetZoomParamFromName(_zoomName: StringName) -> ZoomParameters:
	
	for zoom in zoomParams: 	
		if(zoom.zoomName == _zoomName): return zoom
	
	push_error("No zoom param found")
	return null
	
func GetAveragePosition(nodes: Array) -> Vector3:
	var total_position := Vector3.ZERO
	var count := 0
	
	for node in nodes:
		if node is Node3D:
			total_position += node.global_transform.origin
			count += 1
	
	if count == 0:
		return Vector3.ZERO
	
	return total_position / count
	
	
func AddCameraTarget(newTarget:Node3D):
	if(cameraTargets.has(newTarget)): return
	cameraTargets.append(newTarget)
	
	
func RemoveCameraTarget(targetToRemove:Node3D):
	if(!cameraTargets.has(targetToRemove)): return
	cameraTargets.erase(targetToRemove)
	
	#func ZoomOnTarget(_targetNode: Node3D,_zoomDistance: float = 1.0,_zoomDuration: float = 2.0,_zoomCurve: Curve = zoomCurve):
	#if(_targetNode == null): return
	#
	#updateXYposition = false
	#updateZposition = false
	#inZoomMode = true
	#
	#if TweenCamZ:
		#TweenCamZ.kill()
		#
	#if TweenCamXY:
		#TweenCamXY.kill()
		#
	#var _initPos = global_position
	#var _targetPos = Vector3(_targetNode.global_position.x,_targetNode.global_position.y,_zoomDistance)
	#
	#
	#
	##zoom in
	#var zoomInTimer = get_tree().create_timer(_zoomDuration,true,false,false)
	#
	##XY axis
	#var TweenPos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	#TweenPos.tween_property(self,"position:x",_targetPos.x,_zoomDuration)
	#TweenPos.tween_property(self,"position:y",_targetPos.y,_zoomDuration)
	#
	##Z axis
	#var TweenZoom = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	#TweenPos.tween_property(self,"position:z",_targetPos.z,_zoomDuration)
	#
	#await  zoomInTimer.timeout
#
#
	##reset
	#updateXYposition = true
	#updateZposition = true
	#inZoomMode = false
