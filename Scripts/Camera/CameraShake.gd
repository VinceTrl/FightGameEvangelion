class_name CameraShake

extends Node3D

#camera shake
@export var shakeTime = 0.5
@export var magnitude = 0.025

#advanced camera shake
@export var advancedShakeTime = 2
@export var minMagnitude = 0.005
@export var maxMagnitude = 0.05
@export var magnitudeOverTime: Curve

@export var shakeParams: Array[ShakeParameters] = []

var isShaking: bool = false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	debugCamera()

func debugCamera() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		#SimpleCameraShake()
		#AdvancedCameraShake()
		LaunchCameraShakeParams(GetShakeParamFromName("ImpactShake"))
	
	
func SimpleCameraShake(_magnitude: float = magnitude ,_shakeTime: float = shakeTime):
	if(isShaking): return
	
	var initial_transform = self.transform 
	var elapsed_time = 0.0
	isShaking = true
	
	var shakeTimer = get_tree().create_timer(_shakeTime,true,false,false)
	
	while shakeTimer.time_left > 0.0:
		#print(str(shakeTimer.time_left))
		
		var offset = Vector3(randf_range(-magnitude, magnitude),randf_range(-magnitude, magnitude),0.0)
		self.transform.origin = initial_transform.origin + offset
		await get_tree().process_frame

	isShaking = false
	self.transform = initial_transform
	
	
func AdvancedCameraShake(_minMagnitude: float = minMagnitude,_maxMagnitude: float = maxMagnitude ,_time: float = shakeTime, _curve: Curve = magnitudeOverTime):
	if(isShaking): return
	
	var initial_transform = self.transform 
	var elapsed_time = 0.0
	isShaking = true
	
	var shakeTimer = get_tree().create_timer(_time,true,false,false)
	
	while shakeTimer.time_left > 0.0:
		#print(str(shakeTimer.time_left))
		
		#get magnitude value from curve
		var _timeProgress = _time - shakeTimer.time_left 
		var _ratio = _timeProgress/_time
		var _curveValue = _curve.sample(_ratio)
		var _magnitude = lerp(_minMagnitude,_maxMagnitude,_curveValue)
		
		#set offset for shaking
		var offset = Vector3(randf_range(-_magnitude, _magnitude),randf_range(-_magnitude, _magnitude),0.0)
		
		#apply offset to transform
		self.transform.origin = initial_transform.origin + offset
		await get_tree().process_frame

	#reset
	isShaking = false
	self.transform = initial_transform
	
func LaunchCameraShakeParams(_parameters: ShakeParameters):
	if(_parameters == null): return
	
	var _minMagn = _parameters.minMagnitude
	var _maxMagn = _parameters.maxMagnitude
	var _shakeTime = _parameters.shakeTime
	var _magnOverTime = _parameters.magnitudeOverTime
	
	AdvancedCameraShake(_minMagn,_maxMagn,_shakeTime,_magnOverTime)
	
func AskCamShake(_name: StringName):
	LaunchCameraShakeParams(GetShakeParamFromName(_name))
	

func GetShakeParamFromName(_shakeName: StringName) -> ShakeParameters:
	
	for shake in shakeParams: 	
		if(shake.shakeName == _shakeName): return shake
	
	push_error("No shake param found")
	return null

#func _camera_shake(_magnitude: float = magnitude ,_shakeTime: float = shakeTime,_curve: Curve =  magnitudeOverTime):
	#var initial_transform = self.transform 
	#var elapsed_time = 0.0
#
	#while elapsed_time < _shakeTime:
		#var offset = Vector3(randf_range(-magnitude, magnitude),randf_range(-magnitude, magnitude),0.0)
#
		#self.transform.origin = initial_transform.origin + offset
		#elapsed_time += get_process_delta_time()
		#await get_tree().process_frame
#
	#self.transform = initial_transform
