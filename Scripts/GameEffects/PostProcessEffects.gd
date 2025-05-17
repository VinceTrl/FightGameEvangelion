extends Node

@onready var gameplay_post_process: PostProcess = $GameplayPostProcess

@export var speedLinesEffectTime = 2.0
@export var speedLinesAnimationCurve: Curve
@export var targetConfig: PostProcessingConfiguration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugPostProcess()
	
	
func DebugPostProcess() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		SpeedLineEffect()
	
func SpeedLineEffect():
	
	var _init_speedLinesDensity = gameplay_post_process.configuration.SpeedLineDensity
	var _init_speedLinesCount = gameplay_post_process.configuration.SpeedLinesCount
	var _init_speedLinesSpeed = gameplay_post_process.configuration.SpeedLineSpeed
	
	var speedLineTimer = get_tree().create_timer(speedLinesEffectTime,true,false,false)
	
	while speedLineTimer.time_left > 0.0:
		var _timeProgress = speedLinesEffectTime - speedLineTimer.time_left 
		var _ratio = _timeProgress/speedLinesEffectTime
		var _curveValue = speedLinesAnimationCurve.sample(_ratio)
		var _animValueDensity = lerp(_init_speedLinesDensity,targetConfig.SpeedLineDensity,_curveValue)
		var _animValueSpeed = lerp(_init_speedLinesSpeed,targetConfig.SpeedLineSpeed,_curveValue)
		
		gameplay_post_process.configuration.SpeedLineDensity = _animValueDensity
		gameplay_post_process.configuration.SpeedLineSpeed = _animValueSpeed
		
		await get_tree().process_frame
		
	gameplay_post_process.configuration.SpeedLineDensity = _init_speedLinesDensity
	gameplay_post_process.configuration.SpeedLineSpeed = _init_speedLinesSpeed
