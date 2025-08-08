extends AnimationPlayer

const ANIMATION_TIME_SCALE = preload("res://Resources/Curves/animation_time_scale.tres")
@export var speedScaleCurve:Curve = ANIMATION_TIME_SCALE
@export var ignoreTimeScale: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ScaleAnimSpeed()
	#Debug()
	
func ScaleAnimSpeed():
	if(ignoreTimeScale):
		var timeScale = Engine.time_scale
		timeScale = clampf(timeScale,0.0,1.0)
		var animScale = speedScaleCurve.sample(timeScale)
		speed_scale = animScale
	else:
		speed_scale = 1.0
	
	
func Debug():
	if(Input.is_action_just_pressed("DebugKey")):
		Manager.gameManager.timeManager.slowMotion()
