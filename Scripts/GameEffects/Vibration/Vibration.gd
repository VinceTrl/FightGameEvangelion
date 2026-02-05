class_name Vibration
extends Node

@export var vibrationParams: VibrationParameters

var isVibrating = false
var vibrationLaunched = false
var targetDevice = 0
var time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	HandleVibration(delta)
	
func StartVibration(_device: int,_vibrationParams: VibrationParameters = vibrationParams):
	vibrationParams = _vibrationParams
	targetDevice = _device
	isVibrating = true
	vibrationLaunched = true
	time = 0.0
	#print("start vibration")

func HandleVibration(_delta: float):
	if(!isVibrating): return
	
	
	if time < vibrationParams.duration:
		time += _delta
		
		var _timeRatio = time/vibrationParams.duration
		var _wMagnitude = vibrationParams.weakMagnitude.sample(_timeRatio);
		var _sMagnitude = vibrationParams.strongMagnitude.sample(_timeRatio);
		
		Input.start_joy_vibration(targetDevice,_wMagnitude,_sMagnitude,_delta)
		#print("VIBRATING")
		
	elif(vibrationParams.loop == true):
		time = 0.0
	else:
		time = 0.0
		isVibrating = false
		#print("VIBRATION FINISHED")
		queue_free()
		
func PauseVibration():
	if(!vibrationLaunched):return
	isVibrating = false
	
func ResumeVibration():
	if(!vibrationLaunched):return
	isVibrating = true
	
func StopVibration():
	time = 0.0
	isVibrating = false
	queue_free()
