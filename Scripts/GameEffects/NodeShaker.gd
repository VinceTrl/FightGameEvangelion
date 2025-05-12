class_name NodeShaker
extends Node3D

var isShakingNode = false
var magnitude: float = 0.05
var shakeTime = 0.25
var frequency = 2.00


func _process(delta: float) -> void:
	debugShake()

func debugShake() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		NodeShake()
	
	

func NodeShake(_magnitude: float = magnitude ,_shakeTime: float = shakeTime):
	if(isShakingNode): return
	
	var initial_transform = self.transform 
	var elapsed_time = 0.0
	var freq = 0.0
	isShakingNode = true
	
	var shakeTimer = get_tree().create_timer(_shakeTime,true,false,false)
	
	while shakeTimer.time_left > 0.0:
		#print(str(shakeTimer.time_left))
		
		freq += 1
		if(freq > frequency):
			var offset = Vector3(randf_range(-magnitude, magnitude),randf_range(-magnitude, magnitude),0.0)
			self.transform.origin = initial_transform.origin + offset
			freq = 0.0
		
		await get_tree().process_frame

	isShakingNode = false
	self.transform = initial_transform
