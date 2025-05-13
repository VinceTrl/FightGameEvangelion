class_name NodeShaker
extends Node3D

@export var nodeToShake: Node3D
@export var debugMode: bool = false
@export var magnitude: float = 0.05
@export var shakeTime = 0.25
@export var frequency = 2.00

var isShakingNode = false



func _ready():
	pass

func _process(delta: float) -> void:
	debugShake()

func debugShake() -> void:
	if(debugMode):
		if(Input.is_action_just_pressed("DebugKey")):
			NodeShake()

func NodeShake(_magnitude: float = magnitude ,_shakeTime: float = shakeTime):
	if(isShakingNode): return
	
	var initial_transform = nodeToShake.transform 
	var elapsed_time = 0.0
	var freq = 0.0
	isShakingNode = true
	
	var shakeTimer = get_tree().create_timer(_shakeTime,true,false,false)
	
	while shakeTimer.time_left > 0.0:
		#print(str(shakeTimer.time_left))
		
		freq += 1
		if(freq > frequency):
			var offset = Vector3(randf_range(-magnitude, magnitude),randf_range(-magnitude, magnitude),0.0)
			nodeToShake.transform.origin = initial_transform.origin + offset
			freq = 0.0
		
		await get_tree().process_frame

	isShakingNode = false
	nodeToShake.transform = initial_transform
