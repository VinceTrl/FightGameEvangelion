class_name GameCamera

extends Node3D

const CAMERA_DISTANCE_CURVE = preload("res://Resources/Curves/CameraDistanceCurve.tres")

@export var player1: PlayerCharacter
@export var player2: PlayerCharacter
@export var cameraTargets: Array[Node3D] = []

@export var minDistZ = 2.0
@export var maxDistZ = 4.5
@export var minPlayerDist = 3.5
@export var maxPlayerDist = 8
@export var zDistCurve: Curve = CAMERA_DISTANCE_CURVE

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

@export_category("Margins")
@export var marginHorizontal:int = 100
@export var marginVertical:int = 100
@export var distanceInMargin = 2.0


@onready var camShake: CameraShake = $CameraShake
@onready var camera: Camera3D = $CameraShake/CameraRoll/Camera3D
@onready var camera_roll: Node3D = $CameraShake/CameraRoll


var debugMode = false
@onready var center_debug_label: Label3D = $CENTER_DEBUG_LABEL
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var debug_values: Label = $CanvasLayer/DEBUG_VALUES
@onready var cam_center: Sprite3D = $Cam_Center

var followPlayers: bool = true
var usePlayerDistanceForTargetZ = true
var useOverrideZ = false
var overrideTargetZ = 3.0
var canAddTargets = true

#offset var
var currentOffset = cameraOffset
var isOverridingCameraOffset :bool = false
var overrideOffset :Vector3 = Vector3.ZERO

var updateZposition = true
var updateXYposition = true
var inZoomMode = false
var lastZoomParameters

#TWEEN VARIABLES
var TweenCamXY
var TweenCamZ

signal OnZoomStart
signal OnZoomEnd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameCamera = self
	Manager.OnFightFinish.connect(OnFightFinished)
	currentOffset = cameraOffset
	call_deferred("GetPlayers")
	call_deferred("ResetCameraPosition")
	
	debugMode = Manager.gameDebug.debugCamera
	
	if(debugMode): 
		center_debug_label.visible = true
		canvas_layer.visible = true
		debug_values.visible = true
		cam_center.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdatePositon_XY()
	UpdatePositon_Z()
	ClampCameraPosition()
	DebugCamera()
	

func DebugCamera():
	if(!debugMode): return
	#var _currentDistPlayers: float = player1.global_position.distance_to(player2.global_position)
	var _currentDistPlayers: float = GetMaxDistanceInArray(cameraTargets) + DetectTargetInForbiddenMargins()
	var _playersDistRatio = _currentDistPlayers / maxPlayerDist
	var _curveValue = zDistCurve.sample(_playersDistRatio);
	var _zPos = lerp(minDistZ,maxDistZ,_curveValue)
	
	
	var debug_dist = "\n /player dist : " + str(_currentDistPlayers)
	var debug_zCam = "\n /cam z dist : " + str(_zPos)
	var debug_distRatio = "\n /player ratio dist : " + str(_playersDistRatio)
	var debug_posX = "\n /Cam X : " + str(global_position.x)
	var debug_posY = "\n /Cam Y : " + str(global_position.y)
	var debug_zoomMode = "\n /ZOOM MODE : " + str(inZoomMode)
	var debug_zoomParam = "\n /LAST ZOOM : " + str(lastZoomParameters)
	debug_values.text = "DEBUG CAMERA : " + debug_dist + debug_distRatio + debug_zCam + debug_posX + debug_posY + debug_zoomMode + debug_zoomParam
	
	if(Input.is_action_just_pressed("DebugKey")):
		#SimpleCameraShake()
		#AdvancedCameraShake()
		#CameraZoom(player1)
		FocusTargetZoom(player1,GetZoomParamFromName("MidFocusZoom"))


func GetPlayers():
	for target in cameraTargets:
		if(target is PlayerCharacter):
			if(target.playerID == 1):
				player1 = target
			elif(target.playerID == 2):
				player2 = target
				
func ResetCameraPosition():
	var targetPosXY = GetAveragePosition(cameraTargets)
	var targetPosZ = GetZtargetPosition()
	var targetPos = Vector3(targetPosXY.x,targetPosXY.y,targetPosZ)
	position = targetPos
	
	
func UpdatePositon_XY():
	if(!updateXYposition): return
	
	#print("update XY")
	#var _middlePos: Vector3 = player1.global_position + player2.global_position/2
	#var _middlePos: Vector3 = 0.5 * (player1.global_position + player2.global_position)
	var _middlePos = GetAveragePosition(cameraTargets)
	var _newPos: Vector3 = Vector3(_middlePos.x,_middlePos.y,global_position.z) + GetCameraOffset()
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
		#print("DIST Z APPLIED = " + str(_currentZ))
		
	if(useOverrideZ):
		_currentZ = overrideTargetZ
		#print("OVERRIDE Z APPLIED = " + str(_currentZ))
	
	if TweenCamZ:
		TweenCamZ.kill()
		
	TweenCamZ = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	TweenCamZ.tween_property(self,"position:z",_currentZ,cameraSmoothnessZ)
	#print("Z APPLIED = " + str(_currentZ))
	#global_position.z = _currentZ #TEMP
	
	
func ClampCameraPosition():
	if(!canClampPosition): return
	
	#print("update Z")
	var _clampPosMin = Vector3(cameraClampMin.x,cameraClampMin.y,-100)
	var _clampPosMax = Vector3(cameraClampMax.x,cameraClampMax.y,100)
	
	global_position = global_position.clamp(_clampPosMin,_clampPosMax)

func GetZtargetPosition() -> float:
	#var _currentDistPlayers: float = player1.global_position.distance_to(player2.global_position)
	var _currentDistPlayers: float = GetMaxDistanceInArray(cameraTargets) + DetectTargetInForbiddenMargins()
	var _playersDistRatio = _currentDistPlayers / maxPlayerDist
	var _curveValue = zDistCurve.sample(_playersDistRatio);
	var _zPos = lerp(minDistZ,maxDistZ,_curveValue)
	#print("Z TARGET = " + str(_zPos))
	
	return _zPos
	
	
func DetectTargetInForbiddenMargins() -> float:
	
	var totalDistance:float = 0.0
	
	for node in cameraTargets:
		var screen_pos = camera.unproject_position(node.global_position)
		var viewport_size = get_viewport().size
		var distanceRatio:float = 0.0

		if screen_pos.x < marginHorizontal:
			distanceRatio = screen_pos.x / marginHorizontal
		elif screen_pos.x > viewport_size.x - marginHorizontal:
			distanceRatio = screen_pos.x / viewport_size.x
		elif screen_pos.y < marginVertical: 
			distanceRatio = screen_pos.y / marginVertical
		elif screen_pos.y > viewport_size.y - marginVertical:
			distanceRatio = screen_pos.y / viewport_size.y
			
		totalDistance += lerp(0.0,distanceInMargin,distanceRatio)
		#else:
			#pass
	if(totalDistance > 0.0):
		print("ADDITIONNAL DIST WITH MARGINS AT : "  + str(totalDistance))
		
	return totalDistance
	
func GetCameraOffset() -> Vector3:
	if(isOverridingCameraOffset):
		return overrideOffset
	return cameraOffset
	
func OverrideCameraOffset(_offset:Vector3):
	overrideOffset = _offset
	isOverridingCameraOffset = true
	
func ResetCameraOffset():
	isOverridingCameraOffset = false
	
#zoom that ignores zoom distance
func FocusTargetZoom(_target: Node3D,_zoomParams: ZoomParameters = defaultZoom):
	lastZoomParameters = _zoomParams.zoomName
	ZoomOnTarget(_target,_zoomParams.targetOffset,GetZtargetPosition(),_zoomParams.zoomDuration,_zoomParams.zoomCurve,_zoomParams.translationCurve,true,true)
	
func CameraZoom(_target: Node3D,_zoomParams: ZoomParameters = defaultZoom):
	if(_target == null): return
	lastZoomParameters = _zoomParams.zoomName
	ZoomOnTarget(_target,_zoomParams.targetOffset,_zoomParams.zoomDistance,_zoomParams.zoomDuration,_zoomParams.zoomCurve,_zoomParams.translationCurve)

func ZoomOnTarget(_targetNode: Node3D,_targetOffset:Vector3 = Vector3.ZERO,_zoomDistance: float = defaultZoom.zoomDistance,_zoomDuration: float = defaultZoom.zoomDuration,_zoomCurve: Curve = defaultZoom.zoomCurve,_transCurve: Curve = defaultZoom.translationCurve,_keepCamUpdateXY: bool = false,_keepCamUpdateZ: bool = false):
	if(_targetNode == null): return
	
	updateXYposition = _keepCamUpdateXY
	updateZposition = _keepCamUpdateZ
	
	if TweenCamZ and !_keepCamUpdateZ:
		TweenCamZ.kill()
		
	if TweenCamXY and !_keepCamUpdateXY:
		TweenCamXY.kill()
		
	inZoomMode = true
	
	var _initPos = global_position
	var _targetPos = _targetNode.global_position + _targetOffset
	var zoomTimer = get_tree().create_timer(_zoomDuration,true,false,false)
	
	emit_signal("OnZoomStart")
	
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
	ResetCameraOffset()
	emit_signal("OnZoomEnd")
	
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
	
func GetMaxDistanceInArray(nodes: Array) -> float:
	var max_distance := 0.0

	for i in range(nodes.size()):
		for j in range(i + 1, nodes.size()):
			var pos_a = nodes[i].global_position
			var pos_b = nodes[j].global_position
			var distance = pos_a.distance_to(pos_b)

			if distance > max_distance:
				max_distance = distance

	return max_distance
	
	
func AddCameraTarget(newTarget:Node3D):
	if(!canAddTargets): return
	if(cameraTargets.has(newTarget)): return
	cameraTargets.append(newTarget)
	
	
func RemoveCameraTarget(targetToRemove:Node3D):
	if(!cameraTargets.has(targetToRemove)): return
	cameraTargets.erase(targetToRemove)
	
func RemoveAllTargetsExceptPlayers():
	for target in cameraTargets:
		if(!target is PlayerCharacter):
			RemoveCameraTarget(target)
			
func OnFightFinished():
	canAddTargets = false
	RemoveAllTargetsExceptPlayers()
	
func SetCameraOverrideZ(newTargetZ:float):
	var z = clampf(newTargetZ,minDistZ,maxDistZ)
	overrideTargetZ = z
	useOverrideZ = true
	usePlayerDistanceForTargetZ = false
	
func ResetCameraOverrideZ():
	useOverrideZ = false
	usePlayerDistanceForTargetZ = true
	
func OverrideMinMaxDist(newMinZ:float,newMaxZ:float):
	#var minZ = clampf(newMinZ,minDistZ,maxDistZ)
	#var maxZ = clampf(newMaxZ,minDistZ,maxDistZ)
	minDistZ = newMinZ
	maxDistZ = newMaxZ
	
