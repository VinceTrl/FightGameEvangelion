class_name ControlShaker
extends Control

@export var controlToShake: Control
@export var debugMode: bool = false
@export var magnitude: float = 16
@export var shakeTime = 0.75
@export var frequency = 1.00

var isShakingNode = false
var basePosition:Vector2



func _ready():
	if(!controlToShake):
		controlToShake = self
		print("AUTO ASSIGN NODE TO SHAKE IN CONTROL SHAKER ON : " + str(owner.name))
		
	basePosition = controlToShake.position

func _process(delta: float) -> void:
	debugShake()

func debugShake() -> void:
	if(debugMode):
		if(Input.is_action_just_pressed("DebugKey")):
			NodeShake()

func NodeShake(_magnitude: float = magnitude ,_shakeTime: float = shakeTime):
	if(isShakingNode): return
	
	var initial_pos = basePosition 
	var elapsed_time = 0.0
	var freq = 0.0
	isShakingNode = true
	
	var shakeTimer = get_tree().create_timer(_shakeTime,true,false,false)
	
	while shakeTimer.time_left > 0.0:
		#print(str(shakeTimer.time_left))
		
		freq += 1
		if(freq > frequency):
			var offset = Vector2(randf_range(-magnitude, magnitude),randf_range(-magnitude, magnitude))
			controlToShake.position = initial_pos + offset
			freq = 0.0
		
		await get_tree().process_frame

	isShakingNode = false
	controlToShake.position = initial_pos
